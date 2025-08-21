import 'package:echowater/core/domain/domain_models/notification_domain.dart';
import 'package:json_annotation/json_annotation.dart';

import 'custom_notification_entity.dart';

part 'notification_entity.g.dart';

@JsonSerializable()
class NotificationEntity {
  NotificationEntity(
      this.id,
      this.createdAt,
      this.updatedAt,
      this.message,
      this.isRead,
      this.notificationType,
      this.customNotificationEntity,
      this.images);

  factory NotificationEntity.fromJson(Map<String, dynamic> json) =>
      _$NotificationEntityFromJson(json);

  final int id;
  final String createdAt;
  final String updatedAt;
  final String message;
  final bool isRead;
  final String notificationType;
  final CustomNotificationEntity? customNotificationEntity;
  final List<String?> images;

  Map<String, dynamic> toJson() => _$NotificationEntityToJson(this);
  NotificationDomain toDomain() => NotificationDomain(this);
}
