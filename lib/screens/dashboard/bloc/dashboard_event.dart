part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class DashboardFetchUserInfoEvent extends DashboardEvent {
  DashboardFetchUserInfoEvent();
}

class NavigateToPetDetailEvent extends DashboardEvent {
  NavigateToPetDetailEvent(this.petId);
  final String petId;
}

class FetchAllFlasksEvent extends DashboardEvent {
  FetchAllFlasksEvent(this.initatesConnect);
  final bool initatesConnect;
}

class UpdateThemeEvent extends DashboardEvent {
  UpdateThemeEvent(this.theme);
  final AppTheme theme;
}

class InAppNotificationReceivedEvent extends DashboardEvent {
  InAppNotificationReceivedEvent(this.notification, this.appState);
  final InAppNotification notification;
  final NotificationAppState appState;
}

class StartCycleEvent extends DashboardEvent {
  StartCycleEvent(this.flask, this.ppmGenerated);
  final AppBleModel flask;
  final double? ppmGenerated;
}

class FetchSystemAccessEvent extends DashboardEvent {}

class FetchFlaskFirmwareVersionEvent extends DashboardEvent {
  FetchFlaskFirmwareVersionEvent(
      {required this.bleVersion,
      required this.mcuVersion,
      required this.flaskSerialId});
  final double? mcuVersion;
  final String? bleVersion;
  final String flaskSerialId;
}
