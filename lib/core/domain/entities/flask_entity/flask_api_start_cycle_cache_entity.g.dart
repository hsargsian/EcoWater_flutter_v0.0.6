// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flask_api_start_cycle_cache_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlaskApiStartCycleCacheEntity _$FlaskApiStartCycleCacheEntityFromJson(
        Map<String, dynamic> json) =>
    FlaskApiStartCycleCacheEntity(
      json['uniqueIdentifier'] as String,
      json['flaskId'] as String,
      (json['ppmValue'] as num).toDouble(),
    );

Map<String, dynamic> _$FlaskApiStartCycleCacheEntityToJson(
        FlaskApiStartCycleCacheEntity instance) =>
    <String, dynamic>{
      'uniqueIdentifier': instance.uniqueIdentifier,
      'flaskId': instance.flaskId,
      'ppmValue': instance.ppmValue,
    };
