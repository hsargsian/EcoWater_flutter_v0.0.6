// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_goal_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialGoalWrapperData _$SocialGoalWrapperDataFromJson(
        Map<String, dynamic> json) =>
    SocialGoalWrapperData(
      (json['results'] as List<dynamic>)
          .map((e) => SocialGoalData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SocialGoalWrapperDataToJson(
        SocialGoalWrapperData instance) =>
    <String, dynamic>{
      'results': instance.socialGoals,
    };
