part of 'tooltip_settings_screen_bloc.dart';

abstract class TooltipSettingsScreenState {}

class TooltipSettingsIdleState extends TooltipSettingsScreenState {}

class TooltipInfoFetchedState extends TooltipSettingsScreenState {}

class TooltipInfoUpdatedState extends TooltipSettingsScreenState {
  TooltipInfoUpdatedState(this.navigateDashboard);
  final bool navigateDashboard;
}

class TooltipApiErrorState extends TooltipSettingsScreenState {
  TooltipApiErrorState(this.errorMessage);
  final String errorMessage;
}
