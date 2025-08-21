import 'package:echowater/core/domain/entities/led_light_color_entity/led_light_color_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'led_light_color_data.g.dart';

@JsonSerializable()
class LedLightColorData {
  LedLightColorData(
    this.id,
    this.isGradient,
    this.title,
    this.colorType,
    this.colorHexs,
  );

  factory LedLightColorData.fromJson(Map<String, dynamic> json) =>
      _$LedLightColorDataFromJson(json);
  final int id;
  @JsonKey(name: 'is_gradient')
  final bool isGradient;
  final String title;
  @JsonKey(name: 'colors')
  final List<String>? colorHexs;
  @JsonKey(name: 'color_type')
  final int? colorType;

  Map<String, dynamic> toJson() => _$LedLightColorDataToJson(this);

  LedLightColorEntity asEntity() =>
      LedLightColorEntity(id, isGradient, title, colorHexs);
}
