part of 'led_color_selector_bloc.dart';

abstract class LedColorSelectorState {}

class LedColorSelectorIdleState extends LedColorSelectorState {}

class FetchingLedColorsState extends LedColorSelectorState {}

class FetchedLedColorsState extends LedColorSelectorState {
  FetchedLedColorsState();
}

class LedColorSelectorApiErrorState extends LedColorSelectorState {
  LedColorSelectorApiErrorState(this.errorMessage);
  final String errorMessage;
}
