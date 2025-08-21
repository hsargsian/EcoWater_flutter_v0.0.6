// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProtocolWrapperData _$ProtocolWrapperDataFromJson(Map<String, dynamic> json) =>
    ProtocolWrapperData(
      (json['results'] as List<dynamic>)
          .map((e) => ProtocolData.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaData.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProtocolWrapperDataToJson(
        ProtocolWrapperData instance) =>
    <String, dynamic>{
      'results': instance.protocols,
      'meta': instance.pageMeta,
    };
