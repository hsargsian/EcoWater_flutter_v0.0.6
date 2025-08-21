// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProtocolData _$ProtocolDataFromJson(Map<String, dynamic> json) => ProtocolData(
      json['id'] as int,
      json['title'] as String,
      json['category'] as String,
      json['image'] as String?,
      json['is_active'] as bool?,
    );

Map<String, dynamic> _$ProtocolDataToJson(ProtocolData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'image': instance.image,
      'is_active': instance.isActive,
    };
