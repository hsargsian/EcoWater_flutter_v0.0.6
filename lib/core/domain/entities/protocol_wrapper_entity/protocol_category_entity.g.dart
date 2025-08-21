// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_category_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProtocolCategoryEntity _$ProtocolCategoryEntityFromJson(
        Map<String, dynamic> json) =>
    ProtocolCategoryEntity(
      json['title'] as String,
      json['key'] as String,
      json['id'] as int,
    );

Map<String, dynamic> _$ProtocolCategoryEntityToJson(
        ProtocolCategoryEntity instance) =>
    <String, dynamic>{
      'title': instance.title,
      'key': instance.key,
      'id': instance.id,
    };
