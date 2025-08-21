part of 'tooltip_settings_screen_bloc.dart';

@immutable
abstract class TooltipSettingsScreenEvent {}

class FetchTooltipInformationEvent extends TooltipSettingsScreenEvent {
  FetchTooltipInformationEvent();
}

class TooltipEditRequestEvent extends TooltipSettingsScreenEvent {
  TooltipEditRequestEvent(this.showTooltip);
  final bool showTooltip;
}
