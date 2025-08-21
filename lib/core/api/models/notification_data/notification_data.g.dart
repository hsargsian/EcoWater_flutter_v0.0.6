// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData(
      json['id'] as int,
      json['created_at'] as String,
      json['updated_at'] as String,
      json['message'] as String,
      json['is_read'] as bool,
      json['notification_type'] as String,
      json['custom_data'] == null
          ? null
          : CustomData.fromJson(json['custom_data'] as Map<String, dynamic>),
      (json['images'] as List<dynamic>).map((e) => e as String?).toList(),
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'message': instance.message,
      'is_read': instance.isRead,
      'notification_type': instance.notificationType,
      'custom_data': instance.customData,
      'images': instance.images,
    };
