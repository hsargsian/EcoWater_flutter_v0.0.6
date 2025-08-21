// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_notification_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomNotificationEntity _$CustomNotificationEntityFromJson(
        Map<String, dynamic> json) =>
    CustomNotificationEntity(
      json['socialGoalId'] as String?,
      json['friendId'] as String?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['url'] as String?,
      json['image'] as String?,
    );

Map<String, dynamic> _$CustomNotificationEntityToJson(
        CustomNotificationEntity instance) =>
    <String, dynamic>{
      'socialGoalId': instance.socialGoalId,
      'friendId': instance.friendId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'url': instance.url,
      'image': instance.image,
    };
