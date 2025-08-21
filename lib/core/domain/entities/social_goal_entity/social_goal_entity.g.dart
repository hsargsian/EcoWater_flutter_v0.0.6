// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_goal_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialGoalEntity _$SocialGoalEntityFromJson(Map<String, dynamic> json) =>
    SocialGoalEntity(
      json['id'] as String,
      json['name'] as String,
      json['bottlePPMType'] as String,
      json['totalValue'] as int,
      (json['weekprogress'] as List<dynamic>)
          .map((e) =>
              SocialGoalWeekProgressEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['participants'] as List<dynamic>)
          .map((e) =>
              SocialGoalParticipantEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      UserEntity.fromJson(json['creator'] as Map<String, dynamic>),
      json['reminder'] == null
          ? null
          : SocialGoalReminderEntity.fromJson(
              json['reminder'] as Map<String, dynamic>),
      json['isDummy'] as bool,
    );

Map<String, dynamic> _$SocialGoalEntityToJson(SocialGoalEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bottlePPMType': instance.bottlePPMType,
      'totalValue': instance.totalValue,
      'weekprogress': instance.weekprogress,
      'participants': instance.participants,
      'creator': instance.creator,
      'reminder': instance.reminder,
      'isDummy': instance.isDummy,
    };
