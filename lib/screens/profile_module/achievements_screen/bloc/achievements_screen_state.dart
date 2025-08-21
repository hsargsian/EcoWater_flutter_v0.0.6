part of 'achievements_screen_bloc.dart';

abstract class AchievementsScreenState {}

class AchievementsScreenIdleState extends AchievementsScreenState {}

class LoadingState extends AchievementsScreenState {}

class FetchedCurrentWeekOneTrainingState extends AchievementsScreenState {
  FetchedCurrentWeekOneTrainingState();
}

class FetchedStatsState extends AchievementsScreenState {
  FetchedStatsState();
}

class AchievementsScreenApiErrorState extends AchievementsScreenState {
  AchievementsScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}
