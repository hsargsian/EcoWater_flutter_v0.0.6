import 'package:echowater/core/domain/domain_models/flask_wrapper_domain.dart';
import 'package:echowater/core/domain/entities/flask_entity/flask_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../page_meta_entity/page_meta_entity.dart';

part 'flask_wrapper_entity.g.dart';

@JsonSerializable()
class FlaskWrapperEntity {
  FlaskWrapperEntity(
    this.flasks,
    this.pageMeta,
  );

  factory FlaskWrapperEntity.fromJson(Map<String, dynamic> json) =>
      _$FlaskWrapperEntityFromJson(json);

  final List<FlaskEntity> flasks;
  final PageMetaEntity pageMeta;

  Map<String, dynamic> toJson() => _$FlaskWrapperEntityToJson(this);
  FlaskWrapperDomain toDomain() => FlaskWrapperDomain(
      pageMeta.hasMore, flasks.map((e) => e.toDomain()).toList());
}
