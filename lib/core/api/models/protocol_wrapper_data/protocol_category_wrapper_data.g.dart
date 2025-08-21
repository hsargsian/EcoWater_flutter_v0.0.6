// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_category_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProtocolCategoryWrapperData _$ProtocolCategoryWrapperDataFromJson(
        Map<String, dynamic> json) =>
    ProtocolCategoryWrapperData(
      (json['results'] as List<dynamic>)
          .map((e) => ProtocolCategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaData.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProtocolCategoryWrapperDataToJson(
        ProtocolCategoryWrapperData instance) =>
    <String, dynamic>{
      'results': instance.protocols,
      'meta': instance.pageMeta,
    };
