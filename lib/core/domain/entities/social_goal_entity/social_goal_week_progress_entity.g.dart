// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_goal_week_progress_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialGoalWeekProgressEntity _$SocialGoalWeekProgressEntityFromJson(
        Map<String, dynamic> json) =>
    SocialGoalWeekProgressEntity(
      json['day'] as String,
      (json['achievements'] as List<dynamic>)
          .map((e) => SocialGoalWeekProgressDayAchievementEntity.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SocialGoalWeekProgressEntityToJson(
        SocialGoalWeekProgressEntity instance) =>
    <String, dynamic>{
      'day': instance.day,
      'achievements': instance.achievements,
    };
