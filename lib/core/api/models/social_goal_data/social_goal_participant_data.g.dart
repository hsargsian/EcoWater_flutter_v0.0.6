// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_goal_participant_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialGoalParticipantData _$SocialGoalParticipantDataFromJson(
        Map<String, dynamic> json) =>
    SocialGoalParticipantData(
      json['has_achieved_social_goal'] as bool,
      UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocialGoalParticipantDataToJson(
        SocialGoalParticipantData instance) =>
    <String, dynamic>{
      'has_achieved_social_goal': instance.hasAchievedSocialGoal,
      'user': instance.user,
    };
