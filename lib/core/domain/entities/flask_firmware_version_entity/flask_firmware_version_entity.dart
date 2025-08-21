import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/flask_firmware_version_domain.dart';

part 'flask_firmware_version_entity.g.dart';

@JsonSerializable()
class FlaskFirmwareVersionEntity {
  FlaskFirmwareVersionEntity(this.currentVersion, this.blePath, this.mcuPath,
      this.imagePaths, this.mandatoryVersionCheck);

  factory FlaskFirmwareVersionEntity.fromJson(Map<String, dynamic> json) =>
      _$FlaskFirmwareVersionEntityFromJson(json);

  final String? currentVersion;
  final String? blePath;
  final String? mcuPath;
  final List<String>? imagePaths;
  final bool mandatoryVersionCheck;

  Map<String, dynamic> toJson() => _$FlaskFirmwareVersionEntityToJson(this);
  FlaskFirmwareVersionDomain toDomain() => FlaskFirmwareVersionDomain(this);
}
