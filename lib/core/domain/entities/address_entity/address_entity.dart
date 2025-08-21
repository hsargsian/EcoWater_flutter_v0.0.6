import 'package:json_annotation/json_annotation.dart';

part 'address_entity.g.dart';

@JsonSerializable()
class AddressEntity {
  AddressEntity(
    this.coordinates,
    this.address,
    this.zipCode,
  );

  factory AddressEntity.fromJson(Map<String, dynamic> json) =>
      _$AddressEntityFromJson(json);

  final List<double> coordinates;
  final String address;
  final String zipCode;

  Map<String, dynamic> toJson() => _$AddressEntityToJson(this);
}
