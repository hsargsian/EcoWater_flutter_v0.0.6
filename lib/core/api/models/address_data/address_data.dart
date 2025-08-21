import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/address_entity/address_entity.dart';

part 'address_data.g.dart';

@JsonSerializable()
class AddressData {
  AddressData(
    this.coordinates,
    this.address,
    this.zipCode,
  );

  factory AddressData.fromJson(Map<String, dynamic> json) =>
      _$AddressDataFromJson(json);

  final List<double>? coordinates;
  final String? address;
  final String? zipCode;

  Map<String, dynamic> toJson() => _$AddressDataToJson(this);

  AddressEntity asEntity() => AddressEntity(
        coordinates ?? [],
        address ?? '',
        zipCode ?? '',
      );
}
