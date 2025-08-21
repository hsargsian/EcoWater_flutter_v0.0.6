// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_through_progress_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalkThroughProgressData _$WalkThroughProgressDataFromJson(
        Map<String, dynamic> json) =>
    WalkThroughProgressData(
      json['has_seen_learning_walkthrough'] as bool,
      json['has_seen_dashboard_walkthrough'] as bool,
      json['has_seen_goal_walkthrough'] as bool,
      json['has_seen_homescreen_walkthrough'] as bool,
    );

Map<String, dynamic> _$WalkThroughProgressDataToJson(
        WalkThroughProgressData instance) =>
    <String, dynamic>{
      'has_seen_learning_walkthrough': instance.hasSeenLearningWalkthrough,
      'has_seen_dashboard_walkthrough': instance.hasSeenDashboardWalkthrough,
      'has_seen_goal_walkthrough': instance.hasSeenGoalWalkthrough,
      'has_seen_homescreen_walkthrough': instance.hasSeenHomescreenWalkthrough,
    };
