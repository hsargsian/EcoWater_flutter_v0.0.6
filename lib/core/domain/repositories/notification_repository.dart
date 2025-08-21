import 'package:echowater/core/domain/entities/notification_entity/notification_count_entity.dart';

import '../../api/resource/resource.dart';
import '../entities/notification_entity/notification_wrapper_entity.dart';

abstract class NotificationRepository {
  Future<Result<NotificationWrapperEntity>> fetchNotifications(
      {required int offset, required int perPage});
  Future<Result<bool>> deleteNotification({required String notificationId});
  Future<Result<bool>> readAllNotifications();
  Future<Result<NotificationCountEntity>> fetchUnreadNotificationCount();
}
