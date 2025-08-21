// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'led_light_color_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedLightColorData _$LedLightColorDataFromJson(Map<String, dynamic> json) =>
    LedLightColorData(
      json['id'] as int,
      json['is_gradient'] as bool,
      json['title'] as String,
      json['color_type'] as int?,
      (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LedLightColorDataToJson(LedLightColorData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_gradient': instance.isGradient,
      'title': instance.title,
      'colors': instance.colorHexs,
      'color_type': instance.colorType,
    };
