// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsEntity _$SettingsEntityFromJson(Map<String, dynamic> json) =>
    SettingsEntity(
      json['promotionalEmails'] as bool,
      json['accountUpdates'] as bool,
      json['progressNotifications'] as bool,
      json['newsNotifications'] as bool,
      json['bottleNotification'] as bool,
    );

Map<String, dynamic> _$SettingsEntityToJson(SettingsEntity instance) =>
    <String, dynamic>{
      'promotionalEmails': instance.promotionalEmails,
      'accountUpdates': instance.accountUpdates,
      'progressNotifications': instance.progressNotifications,
      'newsNotifications': instance.newsNotifications,
      'bottleNotification': instance.bottleNotification,
    };
