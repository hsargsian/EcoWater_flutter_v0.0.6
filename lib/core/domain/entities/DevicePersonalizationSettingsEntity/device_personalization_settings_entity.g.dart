// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_personalization_settings_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevicePersonalizationSettingsEntity
    _$DevicePersonalizationSettingsEntityFromJson(Map<String, dynamic> json) =>
        DevicePersonalizationSettingsEntity(
          hasLedLightSettings: json['hasLedLightSettings'] as bool,
          hasVolumeControls: json['hasVolumeControls'] as bool,
          hasLedModeSettings: json['hasLedModeSettings'] as bool,
          hasSleepWakeSettings: json['hasSleepWakeSettings'] as bool,
        );

Map<String, dynamic> _$DevicePersonalizationSettingsEntityToJson(
        DevicePersonalizationSettingsEntity instance) =>
    <String, dynamic>{
      'hasLedLightSettings': instance.hasLedLightSettings,
      'hasVolumeControls': instance.hasVolumeControls,
      'hasLedModeSettings': instance.hasLedModeSettings,
      'hasSleepWakeSettings': instance.hasSleepWakeSettings,
    };
