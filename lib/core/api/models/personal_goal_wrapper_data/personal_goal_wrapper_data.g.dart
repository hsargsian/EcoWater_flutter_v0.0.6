// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_goal_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalGoalWrapperData _$PersonalGoalWrapperDataFromJson(
        Map<String, dynamic> json) =>
    PersonalGoalWrapperData(
      (json['results'] as List<dynamic>)
          .map((e) => PersonalGoalData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonalGoalWrapperDataToJson(
        PersonalGoalWrapperData instance) =>
    <String, dynamic>{
      'results': instance.personalGoals,
    };
