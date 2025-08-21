import 'package:echowater/core/domain/entities/notification_entity/notification_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'custom_data.dart';

part 'notification_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationData {
  NotificationData(this.id, this.createdAt, this.updatedAt, this.message,
      this.isRead, this.notificationType, this.customData, this.images);

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  final int id;
  final String createdAt;
  final String updatedAt;
  final String message;
  final bool isRead;
  final String notificationType;
  final CustomData? customData;
  final List<String?> images;

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);

  NotificationEntity asEntity() => NotificationEntity(id, createdAt, updatedAt,
      message, isRead, notificationType, customData?.asEntity(), images);
}
