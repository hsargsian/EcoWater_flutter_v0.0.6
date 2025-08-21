part of 'notification_screen_bloc.dart';

abstract class NotificationScreenState {}

class NotificationScreenIdleState extends NotificationScreenState {}

class FetchingNotificationsState extends NotificationScreenState {}

class FetchedNotificationsState extends NotificationScreenState {
  FetchedNotificationsState();
}

class NotificationScreenApiErrorState extends NotificationScreenState {
  NotificationScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}
