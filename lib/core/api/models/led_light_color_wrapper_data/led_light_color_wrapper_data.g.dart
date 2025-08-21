// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'led_light_color_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedLightColorWrapperData _$LedLightColorWrapperDataFromJson(
        Map<String, dynamic> json) =>
    LedLightColorWrapperData(
      json['id'] as int,
      json['title'] as String,
      (json['colors'] as List<dynamic>)
          .map((e) => LedLightColorData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LedLightColorWrapperDataToJson(
        LedLightColorWrapperData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'colors': instance.colors,
    };
