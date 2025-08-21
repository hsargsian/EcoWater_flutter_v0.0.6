// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsData _$SettingsDataFromJson(Map<String, dynamic> json) => SettingsData(
      json['promotional_emails'] as bool,
      json['account_updates'] as bool,
      json['progress_notifications'] as bool,
      json['news_notifications'] as bool,
      json['bottle_notifications'] as bool,
    );

Map<String, dynamic> _$SettingsDataToJson(SettingsData instance) =>
    <String, dynamic>{
      'promotional_emails': instance.promotionalEmails,
      'account_updates': instance.accountUpdates,
      'progress_notifications': instance.progressNotifications,
      'news_notifications': instance.newsNotifications,
      'bottle_notifications': instance.bottleNotification,
    };
