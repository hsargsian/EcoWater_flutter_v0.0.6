part of 'protocol_tab_dashboard_screen_bloc.dart';

abstract class ProtocolTabDashboardListingState {}

class ProtocolTabIdleState extends ProtocolTabDashboardListingState {}

class FetchingProtocolCategoriesState
    extends ProtocolTabDashboardListingState {}

class FetchedProtocolCategoriesState extends ProtocolTabDashboardListingState {
  FetchedProtocolCategoriesState();
}

class ProtocolTabFetchApiErrorState extends ProtocolTabDashboardListingState {
  ProtocolTabFetchApiErrorState(this.errorMessage);
  final String errorMessage;
}
