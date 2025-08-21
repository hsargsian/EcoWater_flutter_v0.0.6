import 'package:echowater/core/domain/domain_models/flask_firmware_version_domain.dart';
import 'package:echowater/core/domain/domain_models/led_light_color_domain.dart';
import 'package:echowater/core/domain/entities/flask_entity/flask_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../oc_libraries/ble_service/app_ble_model.dart';

class FlaskDomain extends Equatable {
  FlaskDomain(this._flaskEntity);
  final FlaskEntity _flaskEntity;
  FlaskEntity get entity => _flaskEntity;
  AppBleModel? appBleModelDevice;
  String get id => _flaskEntity.id;
  String get serialId => _flaskEntity.serialId;

  bool get hasAppBleModel => appBleModelDevice != null;

  LedLightColorDomain? get color => _flaskEntity.selectedColor == null
      ? null
      : LedLightColorDomain(_flaskEntity.selectedColor!);

  bool hasUpgradeVersion(FlaskFirmwareVersionDomain? comparableVersionInfo) {
    if (comparableVersionInfo == null) {
      return false;
    }
    return comparableVersionInfo.blePath != null ||
        comparableVersionInfo.mcuPath != null ||
        (comparableVersionInfo.imagePath ?? []).isNotEmpty;
  }

  @override
  List<Object?> get props => [id];

  String get name => _flaskEntity.name;
  double get flaskVolume => _flaskEntity.flaskVolume;
  int get wakeUpFromSleepTime => _flaskEntity.wakeUpFromSleepTime;

  bool get isPaired => !_flaskEntity.isPaired;

  bool get isLightMode => _flaskEntity.isLightMode;
  String get aliasId => _flaskEntity.serialId;
  String? get bleVersion => _flaskEntity.bleVersion;
  String? get mcuVersion => _flaskEntity.mcuVersion;

  void updateLightMode(bool isLightMode) {
    _flaskEntity.isLightMode = isLightMode;
  }
}
