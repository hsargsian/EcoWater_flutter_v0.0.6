// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_access_info_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemAccessInfoData _$SystemAccessInfoDataFromJson(
        Map<String, dynamic> json) =>
    SystemAccessInfoData(
      json['can_access'] as bool,
      json['access_date'] as String,
    );

Map<String, dynamic> _$SystemAccessInfoDataToJson(
        SystemAccessInfoData instance) =>
    <String, dynamic>{
      'can_access': instance.canAccessSystem,
      'access_date': instance.accessDate,
    };
