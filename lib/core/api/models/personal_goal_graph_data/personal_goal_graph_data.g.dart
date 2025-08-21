// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_goal_graph_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalGoalGraphData _$PersonalGoalGraphDataFromJson(
        Map<String, dynamic> json) =>
    PersonalGoalGraphData(
      json['date'] as String,
      json['goal_amount'] as num,
      json['progress'] as num,
    );

Map<String, dynamic> _$PersonalGoalGraphDataToJson(
        PersonalGoalGraphData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'goal_amount': instance.goalAmount,
      'progress': instance.progress,
    };
