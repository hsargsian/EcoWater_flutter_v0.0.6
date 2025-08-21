import 'package:echowater/core/domain/entities/flask_firmware_version_entity/flask_firmware_version_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flask_firmware_version_data.g.dart';

@JsonSerializable()
class FlaskFirmwareVersionData {
  FlaskFirmwareVersionData(this.currentVerion, this.blePath, this.mcuPath,
      this.imagePaths, this.mandatoryVersionCheck);

  factory FlaskFirmwareVersionData.fromJson(Map<String, dynamic> json) =>
      _$FlaskFirmwareVersionDataFromJson(json);

  @JsonKey(name: 'current_version')
  final String? currentVerion;
  @JsonKey(name: 'ble_path')
  final String? blePath;
  @JsonKey(name: 'mcu_path')
  final String? mcuPath;
  @JsonKey(name: 'image_paths')
  final List<String>? imagePaths;
  @JsonKey(name: 'mandatory_version_check')
  final bool? mandatoryVersionCheck;

  Map<String, dynamic> toJson() => _$FlaskFirmwareVersionDataToJson(this);

  FlaskFirmwareVersionEntity asEntity() => FlaskFirmwareVersionEntity(
        currentVerion,
        blePath,
        mcuPath,
        imagePaths,
        mandatoryVersionCheck ?? false,
      );
}
