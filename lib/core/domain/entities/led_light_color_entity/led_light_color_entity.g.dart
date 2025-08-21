// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'led_light_color_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedLightColorEntity _$LedLightColorEntityFromJson(Map<String, dynamic> json) =>
    LedLightColorEntity(
      json['id'] as int,
      json['isGradient'] as bool,
      json['title'] as String,
      (json['colorHexs'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LedLightColorEntityToJson(
        LedLightColorEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isGradient': instance.isGradient,
      'title': instance.title,
      'colorHexs': instance.colorHexs,
    };
