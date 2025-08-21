// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_through_progress_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalkThroughProgressEntity _$WalkThroughProgressEntityFromJson(
        Map<String, dynamic> json) =>
    WalkThroughProgressEntity(
      json['hasSeenHomeScreenWalkThrough'] as bool,
      json['hasSeenGoalScreenWalkThrough'] as bool,
      json['hasSeenLearningScreenWalkThrough'] as bool,
      json['hasSeenProfileScreenWalkThrough'] as bool,
    );

Map<String, dynamic> _$WalkThroughProgressEntityToJson(
        WalkThroughProgressEntity instance) =>
    <String, dynamic>{
      'hasSeenHomeScreenWalkThrough': instance.hasSeenHomeScreenWalkThrough,
      'hasSeenGoalScreenWalkThrough': instance.hasSeenGoalScreenWalkThrough,
      'hasSeenLearningScreenWalkThrough':
          instance.hasSeenLearningScreenWalkThrough,
      'hasSeenProfileScreenWalkThrough':
          instance.hasSeenProfileScreenWalkThrough,
    };
