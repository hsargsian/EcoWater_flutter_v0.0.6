import 'dart:async';

import 'package:echowater/core/services/marketing_push_service/marketing_push_service.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/repositories/auth_repository.dart';
import '../../../../core/domain/repositories/user_repository.dart';
import '../../../../core/injector/injector.dart';
import '../../../device_management/bloc/device_management_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
      {required AuthRepository authenticationRepository,
      required UserRepository userRepository,
      required MarketingPushService marketingPushService})
      : _userRepository = userRepository,
        _authenticationRepository = authenticationRepository,
        _marketingPushService = marketingPushService,
        super(AuthenticationIdleState()) {
    on<AuthenticationStatusChangeEvent>(_onAuthenticated);
    on<ExpireUserSessionEvent>(_onExpireUserSession);
    on<AuthenticationCheckUserSessionEvent>(_onRequestUserSession);
    on<FetchUserInfoEvent>(_onFetchUserInformation);
  }

  final AuthRepository _authenticationRepository;
  final UserRepository _userRepository;
  final MarketingPushService _marketingPushService;

  Future<void> _onExpireUserSession(
      ExpireUserSessionEvent event, Emitter<AuthenticationState> emit) async {
    Injector.instance<DeviceManagementBloc>().add(EvictUserEvent());
    final currentUserId = await _userRepository.getCurrentUserId();
    if (currentUserId == null) {
      await _evitUser();
      return;
    }
    if (event.deleteAccount) {
      await _userRepository.deleteAccount();
      await _evitUser();
    } else {
      await _evitUser();
    }
  }

  Future<void> _evitUser() async {
    await _authenticationRepository.logout();
    _marketingPushService.resetProfile();
    await BleManager().disconnectAllDevices();
    Injector.instance<AuthenticationBloc>()
        .add(AuthenticationStatusChangeEvent(false));
  }

  Future<void> _onRequestUserSession(AuthenticationCheckUserSessionEvent event,
      Emitter<AuthenticationState> emit) async {
    final result = await _authenticationRepository.fetchCachedToken();
    result.whenOrNull(
      success: (token) {
        emit(AuthenticationTokenExistState());
      },
      error: (_) {
        emit(AuthenticationUnauthenticatedState());
      },
    );
  }

  Future<void> _onAuthenticated(AuthenticationStatusChangeEvent event,
      Emitter<AuthenticationState> emit) async {
    if (event.status) {
      emit(AuthenticationAuthenticatedState());
    } else {
      emit(AuthenticationUnauthenticatedState());
    }
  }

  Future<void> _onFetchUserInformation(
    FetchUserInfoEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final response = await _userRepository.fetchUserDetails();
    response.when(success: (user) {
      return AuthenticationAuthenticatedState();
    }, error: (error) {
      _authenticationRepository.logout();
      return AuthenticationUnauthenticatedState();
    });
  }
}
