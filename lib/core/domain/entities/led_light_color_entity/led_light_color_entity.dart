import 'package:echowater/core/domain/domain_models/led_light_color_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'led_light_color_entity.g.dart';

@JsonSerializable()
class LedLightColorEntity {
  LedLightColorEntity(this.id, this.isGradient, this.title, this.colorHexs);

  factory LedLightColorEntity.fromJson(Map<String, dynamic> json) =>
      _$LedLightColorEntityFromJson(json);

  final int id;
  final bool isGradient;
  final String title;
  final List<String>? colorHexs;

  Map<String, dynamic> toJson() => _$LedLightColorEntityToJson(this);
  LedLightColorDomain toDomain() => LedLightColorDomain(this);
}
