import 'notification_domain.dart';

class NotificationWrapperDomain {
  NotificationWrapperDomain(this.hasMore, this.notifications);
  bool hasMore;
  List<NotificationDomain> notifications;

  void remove({required NotificationDomain notification}) {
    notifications.remove(notification);
  }
}
