// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todays_progress_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodaysProgressEntity _$TodaysProgressEntityFromJson(
        Map<String, dynamic> json) =>
    TodaysProgressEntity(
      json['numberOfCycle'] as int,
      json['ppmCount'] as num,
      json['waterCount'] as int?,
      json['numberOfCycleTotal'] as int?,
      json['ppmCountTotal'] as int?,
      json['waterCountTotal'] as int?,
    );

Map<String, dynamic> _$TodaysProgressEntityToJson(
        TodaysProgressEntity instance) =>
    <String, dynamic>{
      'numberOfCycle': instance.numberOfCycle,
      'ppmCount': instance.ppmCount,
      'waterCount': instance.waterCount,
      'numberOfCycleTotal': instance.numberOfCycleTotal,
      'ppmCountTotal': instance.ppmCountTotal,
      'waterCountTotal': instance.waterCountTotal,
    };
