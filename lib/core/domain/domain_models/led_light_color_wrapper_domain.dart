import 'package:echowater/core/domain/domain_models/led_light_color_domain.dart';
import 'package:echowater/core/domain/entities/led_light_color_entity/led_light_color_wrapper_entity.dart';
import 'package:equatable/equatable.dart';

class LedLightColorWrapperDomain extends Equatable {
  const LedLightColorWrapperDomain(this._entity);

  final LedLightColorWrapperEntity _entity;
  List<LedLightColorDomain> get colors =>
      _entity.colors.map(LedLightColorDomain.new).toList();

  @override
  List<Object?> get props => [_entity.title];

  String get title => _entity.title;

  List<LedLightColorDomain> get items =>
      _entity.colors.map(LedLightColorDomain.new).toList();
}
