// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'led_light_color_wrapper_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedLightColorWrapperEntity _$LedLightColorWrapperEntityFromJson(
        Map<String, dynamic> json) =>
    LedLightColorWrapperEntity(
      json['title'] as String,
      (json['colors'] as List<dynamic>)
          .map((e) => LedLightColorEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LedLightColorWrapperEntityToJson(
        LedLightColorWrapperEntity instance) =>
    <String, dynamic>{
      'title': instance.title,
      'colors': instance.colors,
    };
