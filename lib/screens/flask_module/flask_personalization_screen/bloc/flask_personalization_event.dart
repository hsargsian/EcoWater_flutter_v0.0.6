part of 'flask_personalization_bloc.dart';

@immutable
abstract class FlaskPersonalizationEvent {}

class FetchFlaskFirmwareVersionEvent extends FlaskPersonalizationEvent {
  FetchFlaskFirmwareVersionEvent(
      {required this.bleVersion, required this.mcuVersion});
  final double? mcuVersion;
  final String? bleVersion;
}

class SetFlaskDetailEvent extends FlaskPersonalizationEvent {
  SetFlaskDetailEvent({required this.flask});

  final FlaskDomain flask;
}

class UpdateFlaskLightMode extends FlaskPersonalizationEvent {
  UpdateFlaskLightMode({required this.isLightMode});

  final bool isLightMode;
}

class UpdateFlaskVolume extends FlaskPersonalizationEvent {
  UpdateFlaskVolume({required this.volume});

  final double volume;
}

class UpdateFlaskWakeUpFromSleepTime extends FlaskPersonalizationEvent {
  UpdateFlaskWakeUpFromSleepTime({required this.seconds});

  final int seconds;
}

class UpdateFlaskName extends FlaskPersonalizationEvent {
  UpdateFlaskName({required this.title});

  final String title;
}

class UpdateFlaskColor extends FlaskPersonalizationEvent {
  UpdateFlaskColor({required this.color});

  final LedLightColorDomain color;
}

class UpdateFlaskRequestEvent extends FlaskPersonalizationEvent {
  UpdateFlaskRequestEvent(this.id, this.isLightMode, this.name, this.colorId,
      this.volume, this.bleVersion, this.mcuVersion, this.navigatesBack);

  final String id;
  final bool isLightMode;
  final String name;
  final int colorId;
  final double volume;
  final String? bleVersion;
  final String? mcuVersion;
  final bool navigatesBack;
}

class FlaskPersonalizationSettingsEvent extends FlaskPersonalizationEvent {
  FlaskPersonalizationSettingsEvent();
}
