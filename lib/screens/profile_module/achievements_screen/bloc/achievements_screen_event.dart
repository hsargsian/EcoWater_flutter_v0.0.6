part of 'achievements_screen_bloc.dart';

abstract class AchievementsScreenEvent {}

class FetchMyWeekOneTrainingStatsEvent extends AchievementsScreenEvent {
  FetchMyWeekOneTrainingStatsEvent();
}

class FetchUsageStreakEvent extends AchievementsScreenEvent {
  FetchUsageStreakEvent();
}
