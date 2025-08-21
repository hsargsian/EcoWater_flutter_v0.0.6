// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flask_wrapper_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlaskWrapperEntity _$FlaskWrapperEntityFromJson(Map<String, dynamic> json) =>
    FlaskWrapperEntity(
      (json['flasks'] as List<dynamic>)
          .map((e) => FlaskEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaEntity.fromJson(json['pageMeta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FlaskWrapperEntityToJson(FlaskWrapperEntity instance) =>
    <String, dynamic>{
      'flasks': instance.flasks,
      'pageMeta': instance.pageMeta,
    };
