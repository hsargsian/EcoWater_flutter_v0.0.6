// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_attribute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationAttributeModel _$LocationAttributeModelFromJson(
        Map<String, dynamic> json) =>
    LocationAttributeModel(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      address: json['address'] as String,
      zipCode: json['zipCode'] as String,
    );

Map<String, dynamic> _$LocationAttributeModelToJson(
        LocationAttributeModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
      'address': instance.address,
      'zipCode': instance.zipCode,
    };
