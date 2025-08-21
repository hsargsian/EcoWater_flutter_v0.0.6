// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flask_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlaskWrapperData _$FlaskWrapperDataFromJson(Map<String, dynamic> json) =>
    FlaskWrapperData(
      (json['results'] as List<dynamic>)
          .map((e) => FlaskData.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaData.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FlaskWrapperDataToJson(FlaskWrapperData instance) =>
    <String, dynamic>{
      'results': instance.flasks,
      'meta': instance.pageMeta,
    };
