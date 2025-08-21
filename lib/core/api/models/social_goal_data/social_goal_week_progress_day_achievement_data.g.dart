// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_goal_week_progress_day_achievement_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialGoalWeekProgressDayAchievementData
    _$SocialGoalWeekProgressDayAchievementDataFromJson(
            Map<String, dynamic> json) =>
        SocialGoalWeekProgressDayAchievementData(
          json['user_id'] as String,
          json['has_achieved'] as bool,
        );

Map<String, dynamic> _$SocialGoalWeekProgressDayAchievementDataToJson(
        SocialGoalWeekProgressDayAchievementData instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'has_achieved': instance.hasAchieved,
    };
