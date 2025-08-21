import 'package:echowater/core/domain/entities/led_light_color_entity/led_light_color_entity.dart';
import 'package:equatable/equatable.dart';

class LedLightColorDomain extends Equatable {
  const LedLightColorDomain(this._entity);
  final LedLightColorEntity _entity;

  @override
  List<Object?> get props => [_entity.colorHexs];

  bool get isGradientColor => _entity.isGradient;

  String get title => _entity.title;

  int get colorId => _entity.id;

  List<String> get colorHexs => _entity.colorHexs ?? ['#ffffff'];
}
