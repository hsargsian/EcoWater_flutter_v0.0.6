// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_information_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppInformationEntity _$AppInformationEntityFromJson(
        Map<String, dynamic> json) =>
    AppInformationEntity(
      androidLink: json['androidLink'] as String,
      androidVersion: json['androidVersion'] as String,
      iosLink: json['iosLink'] as String,
      iosVersion: json['iosVersion'] as String,
    );

Map<String, dynamic> _$AppInformationEntityToJson(
        AppInformationEntity instance) =>
    <String, dynamic>{
      'androidLink': instance.androidLink,
      'androidVersion': instance.androidVersion,
      'iosLink': instance.iosLink,
      'iosVersion': instance.iosVersion,
    };
