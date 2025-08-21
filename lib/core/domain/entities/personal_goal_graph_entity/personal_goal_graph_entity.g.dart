// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_goal_graph_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalGoalGraphEntity _$PersonalGoalGraphEntityFromJson(
        Map<String, dynamic> json) =>
    PersonalGoalGraphEntity(
      json['date'] as String,
      json['goalAmount'] as num,
      json['progress'] as num,
    );

Map<String, dynamic> _$PersonalGoalGraphEntityToJson(
        PersonalGoalGraphEntity instance) =>
    <String, dynamic>{
      'date': instance.date,
      'goalAmount': instance.goalAmount,
      'progress': instance.progress,
    };
