import 'package:echowater/base/utils/strings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_attribute_model.g.dart';

@JsonSerializable()
class LocationAttributeModel {
  LocationAttributeModel(
      {required this.type,
      required this.coordinates,
      required this.address,
      required this.zipCode});
  factory LocationAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$LocationAttributeModelFromJson(json);
  final String type;
  final List<String> coordinates;
  final String address;
  final String zipCode;

  Map<String, dynamic> toJson() => _$LocationAttributeModelToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool addressInputValidationError = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<String> _validationErrors = [];

  bool get hasError {
    return addressInputValidationError;
  }

  String get formattedErrorMessage {
    return _validationErrors.map((e) => e.localized).join('\n');
  }

  LocationAttributeModel? validate() {
    if (coordinates.isEmpty || address.isEmpty || zipCode.isEmpty) {
      addressInputValidationError = true;
      _validationErrors.add('LocationModel_validationMessage_addAddress');
    }

    return hasError ? this : null;
  }
}
