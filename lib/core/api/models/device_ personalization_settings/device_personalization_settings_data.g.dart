// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_personalization_settings_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevicePersonalizationSettingsData _$DevicePersonalizationSettingsDataFromJson(
        Map<String, dynamic> json) =>
    DevicePersonalizationSettingsData(
      hasLedLightSettings: json['has_led_light_settings'] as bool,
      hasVolumeControls: json['has_volume_controls'] as bool,
      hasLedModeSettings: json['has_led_mode_settings'] as bool,
      hasSleepWakeSettings: json['has_sleep_wake_settings'] as bool,
    );

Map<String, dynamic> _$DevicePersonalizationSettingsDataToJson(
        DevicePersonalizationSettingsData instance) =>
    <String, dynamic>{
      'has_led_light_settings': instance.hasLedLightSettings,
      'has_volume_controls': instance.hasVolumeControls,
      'has_led_mode_settings': instance.hasLedModeSettings,
      'has_sleep_wake_settings': instance.hasSleepWakeSettings,
    };
