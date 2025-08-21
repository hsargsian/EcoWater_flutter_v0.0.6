part of 'help_screen_bloc.dart';

@immutable
abstract class HelpScreenEvent {}

class FetchFaqsEvent extends HelpScreenEvent {
  FetchFaqsEvent();
}
