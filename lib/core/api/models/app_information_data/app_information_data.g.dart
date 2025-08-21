// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_information_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppInformationData _$AppInformationDataFromJson(Map<String, dynamic> json) =>
    AppInformationData(
      json['androidLink'] as String,
      json['androidVersion'] as String,
      json['iosLink'] as String,
      json['iosVersion'] as String,
    );

Map<String, dynamic> _$AppInformationDataToJson(AppInformationData instance) =>
    <String, dynamic>{
      'androidLink': instance.androidLink,
      'androidVersion': instance.androidVersion,
      'iosLink': instance.iosLink,
      'iosVersion': instance.iosVersion,
    };
