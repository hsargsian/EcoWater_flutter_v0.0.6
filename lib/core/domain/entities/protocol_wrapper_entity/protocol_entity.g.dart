// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProtocolEntity _$ProtocolEntityFromJson(Map<String, dynamic> json) =>
    ProtocolEntity(
      json['id'] as String,
      json['title'] as String,
      json['description'] as String,
      json['url'] as String,
      json['isActive'] as bool,
    );

Map<String, dynamic> _$ProtocolEntityToJson(ProtocolEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'isActive': instance.isActive,
    };
