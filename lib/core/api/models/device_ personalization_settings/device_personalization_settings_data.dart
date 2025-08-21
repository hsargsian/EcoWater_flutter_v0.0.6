import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/DevicePersonalizationSettingsEntity/device_personalization_settings_entity.dart';

part 'device_personalization_settings_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DevicePersonalizationSettingsData {
  DevicePersonalizationSettingsData({
    required this.hasLedLightSettings,
    required this.hasVolumeControls,
    required this.hasLedModeSettings,
    required this.hasSleepWakeSettings,
  });

  factory DevicePersonalizationSettingsData.fromJson(Map<String, dynamic> json) =>
      _$DevicePersonalizationSettingsDataFromJson(json);
  final bool hasLedLightSettings;
  final bool hasVolumeControls;
  final bool hasLedModeSettings;
  final bool hasSleepWakeSettings;

  Map<String, dynamic> toJson() => _$DevicePersonalizationSettingsDataToJson(this);

  DevicePersonalizationSettingsEntity asEntity() => DevicePersonalizationSettingsEntity(
      hasLedLightSettings: hasLedLightSettings,
      hasLedModeSettings: hasVolumeControls,
      hasSleepWakeSettings: hasLedModeSettings,
      hasVolumeControls: hasSleepWakeSettings);
}
