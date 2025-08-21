// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_data_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsDataWrapper _$NotificationsDataWrapperFromJson(
        Map<String, dynamic> json) =>
    NotificationsDataWrapper(
      (json['results'] as List<dynamic>)
          .map((e) => NotificationData.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaData.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationsDataWrapperToJson(
        NotificationsDataWrapper instance) =>
    <String, dynamic>{
      'results': instance.notifications,
      'meta': instance.pageMeta,
    };
