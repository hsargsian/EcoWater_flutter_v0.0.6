// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_goal_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialGoalData _$SocialGoalDataFromJson(Map<String, dynamic> json) =>
    SocialGoalData(
      json['id'] as String,
      json['name'] as String,
      json['goal_type'] as String,
      json['goal_number'] as int,
      (json['weekly_progress_data'] as List<dynamic>)
          .map((e) =>
              SocialGoalWeekProgressData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['participants'] as List<dynamic>)
          .map((e) =>
              SocialGoalParticipantData.fromJson(e as Map<String, dynamic>))
          .toList(),
      UserData.fromJson(json['created_by'] as Map<String, dynamic>),
      json['last_reminder'] == null
          ? null
          : SocialGoalReminderData.fromJson(
              json['last_reminder'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocialGoalDataToJson(SocialGoalData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'goal_type': instance.bottlePPMType,
      'goal_number': instance.totalValue,
      'weekly_progress_data': instance.weekProgressData,
      'participants': instance.participants,
      'created_by': instance.creator,
      'last_reminder': instance.reminderData,
    };
