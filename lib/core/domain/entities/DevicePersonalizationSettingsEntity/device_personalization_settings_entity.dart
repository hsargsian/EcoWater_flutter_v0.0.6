import 'package:json_annotation/json_annotation.dart';

part 'device_personalization_settings_entity.g.dart';

@JsonSerializable()
class DevicePersonalizationSettingsEntity {
  DevicePersonalizationSettingsEntity({
    required this.hasLedLightSettings,
    required this.hasVolumeControls,
    required this.hasLedModeSettings,
    required this.hasSleepWakeSettings,
  });

  factory DevicePersonalizationSettingsEntity.fromJson(Map<String, dynamic> json) =>
      _$DevicePersonalizationSettingsEntityFromJson(json);
  final bool hasLedLightSettings;
  final bool hasVolumeControls;
  final bool hasLedModeSettings;
  final bool hasSleepWakeSettings;

  Map<String, dynamic> toJson() => _$DevicePersonalizationSettingsEntityToJson(this);
}
