import 'package:bloc/bloc.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/repositories/goals_and_stats_repository.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/domain_models/user_domain.dart';
import '../../../../core/domain/repositories/user_repository.dart';
import '../../../../core/injector/injector.dart';
import '../../../../oc_libraries/health_kit_service/health_service.dart';
import '../../../auth/authentication/bloc/authentication_bloc.dart';

part 'add_water_screen_event.dart';
part 'add_water_screen_state.dart';

class AddWaterScreenBloc extends Bloc<AddWaterScreenEvent, AddWaterScreenState> {
  AddWaterScreenBloc(
      {required UserRepository userRepository,
      required GoalsAndStatsRepository goalAndStatsRepository,
      required HealthService healthService})
      : _userRepository = userRepository,
        _goalAndStatsRepository = goalAndStatsRepository,
        _healthService = healthService,
        super(IntegrationSettingsIdleState()) {
    on<FetchUserInformationEvent>(_onFetchProfileDetail);
    on<ProfileEditRequestEvent>(_onUpdateProfile);
    on<AddWaterConsumptionEvent>(_onAddWaterConsumption);
  }

  bool hasHealthkitIntegrated = false;
  bool isProfileFetched = false;

  final UserRepository _userRepository;
  final GoalsAndStatsRepository _goalAndStatsRepository;
  UserDomain? profileInformation;
  final HealthService _healthService;

  Future<void> _onUpdateProfile(ProfileEditRequestEvent event, Emitter<AddWaterScreenState> emit) async {
    final currentUser = await _userRepository.getCurrentUserId();
    if (currentUser == null) {
      emit(ProfileEditApiErrorState('user_session_expired_message'.localized));
      Injector.instance<AuthenticationBloc>().add(ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      return;
    }

    if (event.isHealthIntegrationEnabled) {
      final authorized = await _healthService.authorize();
      if (!authorized) {
        emit(ProfileEditApiErrorState('IntegrationScreen_accessPermissionMessage'.localized));
        return;
      }
    }

    emit(UpdatingProfileState());
    final response = await _userRepository.updateUserHealthkitIntegrationPreference(event.isHealthIntegrationEnabled);
    response.when(success: (updateResponse) {
      emit(ProfileUpdateCompleteState('Integration successful'.localized));
      if (!event.isHealthIntegrationEnabled) {
        _healthService.revokeAccess();
      }
      add(FetchUserInformationEvent());
    }, error: (error) {
      emit(ProfileEditApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchProfileDetail(FetchUserInformationEvent event, Emitter<AddWaterScreenState> emit) async {
    final currentUserId = await _userRepository.getCurrentUserId();
    if (currentUserId == null) {
      if (currentUserId == null) {
        emit(ProfileEditApiErrorState('User session has expired'));
        Injector.instance<AuthenticationBloc>().add(ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
        return;
      }
    }
    final response = await _userRepository.fetchUserDetails();
    response.when(success: (userEntity) {
      profileInformation = UserDomain(userEntity, true);
      hasHealthkitIntegrated = profileInformation!.isHealthIntegrationEnabled;
      isProfileFetched = true;
      emit(ProfileFetchedState(profileInformation!));
    }, error: (error) {
      emit(ProfileEditApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onAddWaterConsumption(AddWaterConsumptionEvent event, Emitter<AddWaterScreenState> emit) async {
    final currentUser = await _userRepository.getCurrentUserId();
    if (currentUser == null) {
      emit(ProfileEditApiErrorState('user_session_expired_message'.localized));
      Injector.instance<AuthenticationBloc>().add(ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      return;
    }

    emit(UpdatingProfileState());
    final response = await _goalAndStatsRepository.addWaterConsumption(volume: event.amount);
    response.when(success: (updateResponse) {
      if (hasHealthkitIntegrated) {
        _healthService.addWaterData(double.parse(event.amount.toString()));
      }
      emit(WaterConsumptionAdditionSuccessfulState(updateResponse.message));
    }, error: (error) {
      emit(ProfileEditApiErrorState(error.toMessage()));
    });
  }
}
