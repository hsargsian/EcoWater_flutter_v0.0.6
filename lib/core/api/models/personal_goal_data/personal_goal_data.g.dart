// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_goal_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalGoalData _$PersonalGoalDataFromJson(Map<String, dynamic> json) =>
    PersonalGoalData(
      json['id'] as int,
      json['goal_type'] as String,
      json['goal_number'] as int,
      json['goal_completion'] as num,
    );

Map<String, dynamic> _$PersonalGoalDataToJson(PersonalGoalData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goal_type': instance.bottlePPMType,
      'goal_number': instance.totalValue,
      'goal_completion': instance.completedValue,
    };
