part of 'goals_screen_bloc.dart';

@immutable
abstract class GoalsScreenEvent {}

class FetchUserInformationEvent extends GoalsScreenEvent {}

class FetchWeekOneTrainingSetEvent extends GoalsScreenEvent {
  FetchWeekOneTrainingSetEvent();
}

class FetchMyWeekOneTrainingStatsEvent extends GoalsScreenEvent {
  FetchMyWeekOneTrainingStatsEvent();
}

class UpdateWeekOneTrainingViewEvent extends GoalsScreenEvent {
  UpdateWeekOneTrainingViewEvent(this.currentWeekProgressDay);
  final int currentWeekProgressDay;
}

class CloseWeekOneTrainingViewEvent extends GoalsScreenEvent {
  CloseWeekOneTrainingViewEvent();
}

class FetchUsageStreakEvent extends GoalsScreenEvent {
  FetchUsageStreakEvent();
}

class FetchUsageDatesEvent extends GoalsScreenEvent {
  FetchUsageDatesEvent(this.startDate, this.endDate);
  final String startDate;
  final String endDate;
}
