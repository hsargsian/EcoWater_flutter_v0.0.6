// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_goal_reminder_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialGoalReminderData _$SocialGoalReminderDataFromJson(
        Map<String, dynamic> json) =>
    SocialGoalReminderData(
      json['send_by'] as String,
      json['send_date'] as String,
    );

Map<String, dynamic> _$SocialGoalReminderDataToJson(
        SocialGoalReminderData instance) =>
    <String, dynamic>{
      'send_by': instance.sentBy,
      'send_date': instance.sentDate,
    };
