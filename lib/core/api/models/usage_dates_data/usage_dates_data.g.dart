// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_dates_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsageDatesData _$UsageDatesDataFromJson(Map<String, dynamic> json) =>
    UsageDatesData(
      (json['usage-dates'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UsageDatesDataToJson(UsageDatesData instance) =>
    <String, dynamic>{
      'usage-dates': instance.dates,
    };
