part of 'integration_settings_screen_bloc.dart';

abstract class IntegrationSettingsScreenState {}

class IntegrationSettingsIdleState extends IntegrationSettingsScreenState {}

class ProfileFetchedState extends IntegrationSettingsScreenState {
  ProfileFetchedState(this.userProfile);
  final UserDomain userProfile;
}

class ProfileUpdateCompleteState extends IntegrationSettingsScreenState {
  ProfileUpdateCompleteState(this.message);
  final String message;
}

class UpdatingProfileState extends IntegrationSettingsScreenState {}

class ProfileEditApiErrorState extends IntegrationSettingsScreenState {
  ProfileEditApiErrorState(this.errorMessage);
  final String errorMessage;
}
