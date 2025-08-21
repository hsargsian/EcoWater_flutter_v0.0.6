part of 'led_color_selector_bloc.dart';

@immutable
abstract class LedColorSelectorEvent {}

class FetchAllColorsEvent extends LedColorSelectorEvent {
  FetchAllColorsEvent();
}
