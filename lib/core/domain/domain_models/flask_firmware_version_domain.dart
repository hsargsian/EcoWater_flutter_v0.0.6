import 'package:echowater/core/domain/entities/flask_firmware_version_entity/flask_firmware_version_entity.dart';

class FlaskFirmwareVersionDomain {
  const FlaskFirmwareVersionDomain(this._entity);
  final FlaskFirmwareVersionEntity _entity;

  String? get currentVersion => _entity.currentVersion;
  String? get blePath => _entity.blePath;
  String? get mcuPath => _entity.mcuPath;
  List<String>? get imagePath => _entity.imagePaths;
  bool get hasMandatoryVersionCheck => _entity.mandatoryVersionCheck;

  bool get hasUpgrade =>
      blePath != null || mcuPath != null || (imagePath ?? []).isNotEmpty;
}
