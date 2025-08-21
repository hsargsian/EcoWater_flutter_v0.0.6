import 'package:echowater/core/domain/domain_models/led_light_color_wrapper_domain.dart';
import 'package:echowater/core/domain/entities/led_light_color_entity/led_light_color_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'led_light_color_wrapper_entity.g.dart';

@JsonSerializable()
class LedLightColorWrapperEntity {
  LedLightColorWrapperEntity(this.title, this.colors);

  factory LedLightColorWrapperEntity.fromJson(Map<String, dynamic> json) =>
      _$LedLightColorWrapperEntityFromJson(json);

  final String title;
  final List<LedLightColorEntity> colors;

  Map<String, dynamic> toJson() => _$LedLightColorWrapperEntityToJson(this);
  LedLightColorWrapperDomain toDomain() => LedLightColorWrapperDomain(this);
}
