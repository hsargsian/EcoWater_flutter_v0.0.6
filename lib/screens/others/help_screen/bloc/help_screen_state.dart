part of 'help_screen_bloc.dart';

abstract class HelpScreenState {}

class HelpScreenIdleState extends HelpScreenState {}

class HelpScreenFetchingFaqsState extends HelpScreenState {}

class HelpScreenFetchedFaqsState extends HelpScreenState {
  HelpScreenFetchedFaqsState();
}

class HelpScreenApiErrorState extends HelpScreenState {
  HelpScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}
