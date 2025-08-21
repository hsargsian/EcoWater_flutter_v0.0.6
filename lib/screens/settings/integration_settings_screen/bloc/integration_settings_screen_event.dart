part of 'integration_settings_screen_bloc.dart';

@immutable
abstract class IntegrationSettingsScreenEvent {}

class FetchUserInformationEvent extends IntegrationSettingsScreenEvent {
  FetchUserInformationEvent();
}

class ProfileEditRequestEvent extends IntegrationSettingsScreenEvent {
  ProfileEditRequestEvent(this.isHealthIntegrationEnabled);
  final bool isHealthIntegrationEnabled;
}
