// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressData _$AddressDataFromJson(Map<String, dynamic> json) => AddressData(
      (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      json['address'] as String?,
      json['zipCode'] as String?,
    );

Map<String, dynamic> _$AddressDataToJson(AddressData instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
      'address': instance.address,
      'zipCode': instance.zipCode,
    };
