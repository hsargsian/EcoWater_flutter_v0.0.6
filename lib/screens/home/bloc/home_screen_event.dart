part of 'home_screen_bloc.dart';

@immutable
abstract class HomeScreenEvent {}

class FetchTodayProgressEvent extends HomeScreenEvent {
  FetchTodayProgressEvent();
}

class FetchMyFlasksEvent extends HomeScreenEvent {
  FetchMyFlasksEvent();
}

class FetchUsageStreakEvent extends HomeScreenEvent {
  FetchUsageStreakEvent();
}

class FetchNotificationCountEvent extends HomeScreenEvent {
  FetchNotificationCountEvent();
}

class FetchUserInformationEvent extends HomeScreenEvent {
  FetchUserInformationEvent();
}

class FetchPersonalGoalGraphDataEvent extends HomeScreenEvent {
  FetchPersonalGoalGraphDataEvent(this.startDate, this.endDate, this.goalType);
  final String startDate;
  final String endDate;
  final String goalType;
}
