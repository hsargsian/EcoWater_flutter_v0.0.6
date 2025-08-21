// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetEntity _$AssetEntityFromJson(Map<String, dynamic> json) => AssetEntity(
      id: json['id'] as String?,
      url: json['url'] as String,
      isImage: json['isImage'] as bool,
    );

Map<String, dynamic> _$AssetEntityToJson(AssetEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'isImage': instance.isImage,
    };
