// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'led_color_response_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedColorResponseWrapperData _$LedColorResponseWrapperDataFromJson(
        Map<String, dynamic> json) =>
    LedColorResponseWrapperData(
      (json['results'] as List<dynamic>)
          .map((e) =>
              LedLightColorWrapperData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LedColorResponseWrapperDataToJson(
        LedColorResponseWrapperData instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
