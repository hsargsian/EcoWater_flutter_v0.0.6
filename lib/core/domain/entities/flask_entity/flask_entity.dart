import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/core/domain/entities/led_light_color_entity/led_light_color_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flask_entity.g.dart';

@JsonSerializable()
class FlaskEntity {
  FlaskEntity(
      this.id,
      this.name,
      this.isPaired,
      this.selectedColor,
      this.isLightMode,
      this.serialId,
      this.flaskVolume,
      this.wakeUpFromSleepTime,
      this.bleVersion,
      this.mcuVersion);

  factory FlaskEntity.fromJson(Map<String, dynamic> json) =>
      _$FlaskEntityFromJson(json);

  final String id;
  final String name;
  final bool isPaired;
  final LedLightColorEntity? selectedColor;
  bool isLightMode;
  final String serialId;
  final double flaskVolume;
  final int wakeUpFromSleepTime;
  final String? bleVersion;
  final String? mcuVersion;

  Map<String, dynamic> toJson() => _$FlaskEntityToJson(this);
  FlaskDomain toDomain() => FlaskDomain(this);
}
