part of 'settings_screen_bloc.dart';

abstract class SettingsScreenState {}

class SettingsScreenIdleState extends SettingsScreenState {}

class FetchingSettingsState extends SettingsScreenState {}

class FetchedSettingsState extends SettingsScreenState {
  FetchedSettingsState();
}

class SettingsScreenApiErrorState extends SettingsScreenState {
  SettingsScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}

class UpdatingSettingsState extends SettingsScreenState {
  UpdatingSettingsState();
}

class UpdatedSettingsState extends SettingsScreenState {
  UpdatedSettingsState(this.message);
  final String message;
}
