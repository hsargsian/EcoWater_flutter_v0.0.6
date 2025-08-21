// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_access_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemAccessEntity _$SystemAccessEntityFromJson(Map<String, dynamic> json) =>
    SystemAccessEntity(
      json['canAccessSystem'] as bool,
      json['accessDate'] as String,
    );

Map<String, dynamic> _$SystemAccessEntityToJson(SystemAccessEntity instance) =>
    <String, dynamic>{
      'canAccessSystem': instance.canAccessSystem,
      'accessDate': instance.accessDate,
    };
