import 'package:echowater/core/domain/entities/notification_entity/notification_count_entity.dart';

class NotificationCountDomain {
  const NotificationCountDomain(this._notificationCountEntity);
  final NotificationCountEntity _notificationCountEntity;

  int get count => _notificationCountEntity.count;
  bool get hasUnreadNotifications => count > 0;
}
