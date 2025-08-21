// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_streak_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsageStreakData _$UsageStreakDataFromJson(Map<String, dynamic> json) =>
    UsageStreakData(
      json['current_streak'] as int,
      json['longest_streak'] as int?,
      json['total_hydrogen_consumed'] as num?,
      json['total_bottle_consumed'] as int?,
      json['total_water_consumed'] as int?,
    );

Map<String, dynamic> _$UsageStreakDataToJson(UsageStreakData instance) =>
    <String, dynamic>{
      'current_streak': instance.streakCount,
      'longest_streak': instance.longestStreakCount,
      'total_hydrogen_consumed': instance.totalPPMsCount,
      'total_bottle_consumed': instance.totalBottlesCount,
      'total_water_consumed': instance.totalWaterCount,
    };
