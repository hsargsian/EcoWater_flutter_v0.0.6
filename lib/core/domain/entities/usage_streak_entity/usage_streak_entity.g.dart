// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_streak_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsageStreakEntity _$UsageStreakEntityFromJson(Map<String, dynamic> json) =>
    UsageStreakEntity(
      json['usageStreak'] as int,
      json['longestStreakCount'] as int,
      json['totalBottles'] as int,
      json['totalPPMs'] as num,
      json['totalWaterConsumed'] as int,
    );

Map<String, dynamic> _$UsageStreakEntityToJson(UsageStreakEntity instance) =>
    <String, dynamic>{
      'usageStreak': instance.usageStreak,
      'longestStreakCount': instance.longestStreakCount,
      'totalPPMs': instance.totalPPMs,
      'totalBottles': instance.totalBottles,
      'totalWaterConsumed': instance.totalWaterConsumed,
    };
