// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_wrapper_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProtocolWrapperEntity _$ProtocolWrapperEntityFromJson(
        Map<String, dynamic> json) =>
    ProtocolWrapperEntity(
      (json['protocols'] as List<dynamic>)
          .map((e) => ProtocolEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaEntity.fromJson(json['pageMeta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProtocolWrapperEntityToJson(
        ProtocolWrapperEntity instance) =>
    <String, dynamic>{
      'protocols': instance.protocols,
      'pageMeta': instance.pageMeta,
    };
