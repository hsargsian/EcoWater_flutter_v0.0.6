// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_goal_week_progress_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialGoalWeekProgressData _$SocialGoalWeekProgressDataFromJson(
        Map<String, dynamic> json) =>
    SocialGoalWeekProgressData(
      json['day'] as String,
      (json['achievements'] as List<dynamic>)
          .map((e) => SocialGoalWeekProgressDayAchievementData.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SocialGoalWeekProgressDataToJson(
        SocialGoalWeekProgressData instance) =>
    <String, dynamic>{
      'day': instance.day,
      'achievements': instance.achievements,
    };
