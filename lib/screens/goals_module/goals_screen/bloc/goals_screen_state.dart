part of 'goals_screen_bloc.dart';

abstract class GoalsScreenState {}

class GoalsScreenIdleState extends GoalsScreenState {}

class FetchedUserInformationState extends GoalsScreenState {}

class FetchingWeekOneTrainingState extends GoalsScreenState {}

class FetchedWeekOneTrainingState extends GoalsScreenState {
  FetchedWeekOneTrainingState();
}

class FetchedCurrentWeekOneTrainingState extends GoalsScreenState {
  FetchedCurrentWeekOneTrainingState();
}

class FetchedCalendarEventsState extends GoalsScreenState {
  FetchedCalendarEventsState();
}

class FetchedUsageDatesState extends GoalsScreenState {
  FetchedUsageDatesState();
}

class GoalsScreenApiErrorState extends GoalsScreenState {
  GoalsScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}

class FetchedStatsState extends GoalsScreenState {
  FetchedStatsState();
}
