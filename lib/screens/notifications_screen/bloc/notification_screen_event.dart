part of 'notification_screen_bloc.dart';

@immutable
abstract class NotificationScreenEvent {}

class FetchNotificationsEvent extends NotificationScreenEvent {
  FetchNotificationsEvent(this.fetchStyle);
  final FetchStyle fetchStyle;
}

class DeleteNotificationEvent extends NotificationScreenEvent {
  DeleteNotificationEvent(this.notification);
  final NotificationDomain notification;
}

class ReadAllNotificationEvent extends NotificationScreenEvent {
  ReadAllNotificationEvent();
}
