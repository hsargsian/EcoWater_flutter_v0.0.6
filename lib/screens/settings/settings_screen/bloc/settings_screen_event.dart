part of 'settings_screen_bloc.dart';

@immutable
abstract class SettingsScreenEvent {}

class FetchSettingsEvent extends SettingsScreenEvent {
  FetchSettingsEvent();
}

class SetSettingsTypeEvent extends SettingsScreenEvent {
  SetSettingsTypeEvent(this.settingsType);
  final SettingsType settingsType;
}

class UpdateSettingsEvent extends SettingsScreenEvent {
  UpdateSettingsEvent({required this.notificationSettings});
  final List<Pair<NotificationType, bool>> notificationSettings;
}
