part of 'dashboard_bloc.dart';

abstract class DashboardState {}

class DashboardIdleState extends DashboardState {}

class UserLoggedOutState extends DashboardState {}

class FetchedUserInfoState extends DashboardState {}

class MessageState extends DashboardState {
  MessageState(this.message, this.snackbarStyle);
  final String message;
  final SnackbarStyle snackbarStyle;
}

class FetchedMyFlasksState extends DashboardState {
  FetchedMyFlasksState(this.flasks);
  final List<FlaskDomain> flasks;
}

class FetchedSystemAccessState extends DashboardState {
  FetchedSystemAccessState(this.systemAccessInfo);
  final SystemAccessStateDomain systemAccessInfo;
}

class FlaskFirmwareInfoFetchedState extends DashboardState {
  FlaskFirmwareInfoFetchedState(this.firmwareInfo, this.flask);
  final FlaskFirmwareVersionDomain firmwareInfo;
  final FlaskDomain flask;
}
