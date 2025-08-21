// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_goal_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalGoalEntity _$PersonalGoalEntityFromJson(Map<String, dynamic> json) =>
    PersonalGoalEntity(
      json['id'] as String,
      json['bottlePPMType'] as String,
      json['totalValue'] as int,
      json['completedValue'] as num,
      json['isDummy'] as bool,
    );

Map<String, dynamic> _$PersonalGoalEntityToJson(PersonalGoalEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bottlePPMType': instance.bottlePPMType,
      'totalValue': instance.totalValue,
      'completedValue': instance.completedValue,
      'isDummy': instance.isDummy,
    };
