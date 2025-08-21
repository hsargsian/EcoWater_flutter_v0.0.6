import 'package:bloc/bloc.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/domain_models/user_domain.dart';
import '../../../../core/domain/repositories/user_repository.dart';
import '../../../../core/injector/injector.dart';
import '../../../../oc_libraries/health_kit_service/health_service.dart';
import '../../../auth/authentication/bloc/authentication_bloc.dart';

part 'integration_settings_screen_event.dart';
part 'integration_settings_screen_state.dart';

class IntegrationSettingsScreenBloc extends Bloc<IntegrationSettingsScreenEvent,
    IntegrationSettingsScreenState> {
  IntegrationSettingsScreenBloc(
      {required UserRepository userRepository,
      required HealthService healthService})
      : _userRepository = userRepository,
        _healthService = healthService,
        super(IntegrationSettingsIdleState()) {
    on<FetchUserInformationEvent>(_onFetchProfileDetail);
    on<ProfileEditRequestEvent>(_onUpdateProfile);
  }

  final UserRepository _userRepository;
  UserDomain? profileInformation;
  final HealthService _healthService;

  Future<void> _onUpdateProfile(ProfileEditRequestEvent event,
      Emitter<IntegrationSettingsScreenState> emit) async {
    final currentUser = await _userRepository.getCurrentUserId();
    if (currentUser == null) {
      emit(ProfileEditApiErrorState('user_session_expired_message'.localized));
      Injector.instance<AuthenticationBloc>().add(
          ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      return;
    }

    if (event.isHealthIntegrationEnabled) {
      final authorized = await _healthService.authorize();
      if (!authorized) {
        emit(ProfileEditApiErrorState(
            'IntegrationScreen_accessPermissionMessage'.localized));
        return;
      }
    }

    emit(UpdatingProfileState());
    final response =
        await _userRepository.updateUserHealthkitIntegrationPreference(
            event.isHealthIntegrationEnabled);
    response.when(success: (updateResponse) {
      emit(ProfileUpdateCompleteState(
          'ProfileEditScreen_profileUpdateSuccess'.localized));
      if (!event.isHealthIntegrationEnabled) {
        _healthService.revokeAccess();
      }
      add(FetchUserInformationEvent());
    }, error: (error) {
      emit(ProfileEditApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchProfileDetail(FetchUserInformationEvent event,
      Emitter<IntegrationSettingsScreenState> emit) async {
    final currentUserId = await _userRepository.getCurrentUserId();
    if (currentUserId == null) {
      if (currentUserId == null) {
        emit(ProfileEditApiErrorState('User session has expired'));
        Injector.instance<AuthenticationBloc>().add(
            ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
        return;
      }
    }
    final response = await _userRepository.fetchUserDetails();
    response.when(success: (userEntity) {
      profileInformation = UserDomain(userEntity, true);
      emit(ProfileFetchedState(profileInformation!));
    }, error: (error) {
      emit(ProfileEditApiErrorState(error.toMessage()));
    });
  }
}
