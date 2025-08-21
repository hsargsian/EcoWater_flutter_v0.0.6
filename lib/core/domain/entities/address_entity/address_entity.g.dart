// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressEntity _$AddressEntityFromJson(Map<String, dynamic> json) =>
    AddressEntity(
      (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      json['address'] as String,
      json['zipCode'] as String,
    );

Map<String, dynamic> _$AddressEntityToJson(AddressEntity instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
      'address': instance.address,
      'zipCode': instance.zipCode,
    };
