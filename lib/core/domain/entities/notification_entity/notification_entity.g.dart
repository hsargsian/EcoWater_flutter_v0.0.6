// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationEntity _$NotificationEntityFromJson(Map<String, dynamic> json) =>
    NotificationEntity(
      json['id'] as int,
      json['createdAt'] as String,
      json['updatedAt'] as String,
      json['message'] as String,
      json['isRead'] as bool,
      json['notificationType'] as String,
      json['customNotificationEntity'] == null
          ? null
          : CustomNotificationEntity.fromJson(
              json['customNotificationEntity'] as Map<String, dynamic>),
      (json['images'] as List<dynamic>).map((e) => e as String?).toList(),
    );

Map<String, dynamic> _$NotificationEntityToJson(NotificationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'message': instance.message,
      'isRead': instance.isRead,
      'notificationType': instance.notificationType,
      'customNotificationEntity': instance.customNotificationEntity,
      'images': instance.images,
    };
