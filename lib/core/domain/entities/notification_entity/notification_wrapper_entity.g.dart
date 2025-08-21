// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_wrapper_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationWrapperEntity _$NotificationWrapperEntityFromJson(
        Map<String, dynamic> json) =>
    NotificationWrapperEntity(
      (json['notifications'] as List<dynamic>)
          .map((e) => NotificationEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaEntity.fromJson(json['pageMeta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationWrapperEntityToJson(
        NotificationWrapperEntity instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'pageMeta': instance.pageMeta,
    };
