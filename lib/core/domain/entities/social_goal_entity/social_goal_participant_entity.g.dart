// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_goal_participant_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialGoalParticipantEntity _$SocialGoalParticipantEntityFromJson(
        Map<String, dynamic> json) =>
    SocialGoalParticipantEntity(
      json['hasAchievedSocialGoal'] as bool,
      UserEntity.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocialGoalParticipantEntityToJson(
        SocialGoalParticipantEntity instance) =>
    <String, dynamic>{
      'hasAchievedSocialGoal': instance.hasAchievedSocialGoal,
      'user': instance.user,
    };
