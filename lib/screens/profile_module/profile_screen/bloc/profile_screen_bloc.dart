import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/repositories/auth_repository.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_manager.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/domain_models/user_domain.dart';
import '../../../../core/domain/repositories/user_repository.dart';
import '../../../../core/injector/injector.dart';
import '../../../../theme/app_theme_manager.dart';
import '../../../auth/authentication/bloc/authentication_bloc.dart';

part 'profile_screen_event.dart';
part 'profile_screen_state.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  ProfileScreenBloc({
    required UserRepository userRepository,
    required AuthRepository authRepository,
  })  : _userRepository = userRepository,
        _authRepository = authRepository,
        super(ProfileScreenIdleState()) {
    on<FetchUserInformationEvent>(_onFetchUserProfile);
    on<LogoutUserRequestEvent>(_onLogout);
  }

  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  UserDomain? profileInformation;

  Future<void> _onFetchUserProfile(
    FetchUserInformationEvent event,
    Emitter<ProfileScreenState> emit,
  ) async {
    emit(FetchingProfileState());
    if (event.isFetchingPersonalProfile) {
      final currentUserId = await _userRepository.getCurrentUserId();
      if (currentUserId == null) {
        if (currentUserId == null) {
          emit(ProfileScreenApiErrorState('user_session_expired_message'.localized));
          Injector.instance<AuthenticationBloc>().add(ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
          return;
        }
      }
    }

    final response = await _userRepository.fetchUserDetails();
    response.when(success: (userEntity) {
      emit(FetchingProfileState());
      profileInformation = UserDomain(userEntity, true);
      if (event.isFetchingPersonalProfile) {
        AppThemeManager().changeTheme(profileInformation!.theme);
      }
      emit(ProfileFetchedState(profileInformation!));
    }, error: (error) {
      emit(ProfileScreenApiErrorState(
        error.toMessage(),
      ));
    });
  }

  Future<void> _onLogout(
    LogoutUserRequestEvent event,
    Emitter<ProfileScreenState> emit,
  ) async {
    emit(LogoutState());
    final response = await _userRepository.logOut();
    response.when(success: (logoutResponse) {
      emit(LogedoutState(message: logoutResponse.message));
      _evitUser();
    }, error: (error) {
      _evitUser();
    });
  }

  Future<void> _evitUser() async {
    await _authRepository.logout();
    await BleManager().disconnectAllDevices();
    WalkThroughManager().deinit();

    Injector.instance<AuthenticationBloc>().add(AuthenticationStatusChangeEvent(false));
  }
}
