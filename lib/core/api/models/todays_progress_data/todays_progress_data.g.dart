// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todays_progress_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodaysProgressData _$TodaysProgressDataFromJson(Map<String, dynamic> json) =>
    TodaysProgressData(
      json['number_of_cycle'] as int,
      json['hydrogen_count'] as num,
      json['total_number_of_cycle'] as int?,
      json['total_hydrogen_count'] as int?,
      json['water_amount'] as int?,
      json['total_water_amount'] as int?,
    );

Map<String, dynamic> _$TodaysProgressDataToJson(TodaysProgressData instance) =>
    <String, dynamic>{
      'number_of_cycle': instance.numberOfCycle,
      'hydrogen_count': instance.ppmCount,
      'total_number_of_cycle': instance.numberOfCycleTotal,
      'total_hydrogen_count': instance.ppmCountTotal,
      'water_amount': instance.amountOfWater,
      'total_water_amount': instance.amountOfWaterTotal,
    };
