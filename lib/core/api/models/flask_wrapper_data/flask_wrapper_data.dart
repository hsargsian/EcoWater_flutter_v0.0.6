import 'package:echowater/core/domain/entities/flask_entity/flask_wrapper_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../flask_data/flask_data.dart';
import '../page_meta_data/page_meta_data.dart';

part 'flask_wrapper_data.g.dart';

@JsonSerializable()
class FlaskWrapperData {
  FlaskWrapperData(this.flasks, this.pageMeta);

  factory FlaskWrapperData.fromJson(Map<String, dynamic> json) =>
      _$FlaskWrapperDataFromJson(json);
  @JsonKey(name: 'results')
  final List<FlaskData> flasks;
  @JsonKey(name: 'meta')
  final PageMetaData pageMeta;

  FlaskWrapperEntity asEntity() => FlaskWrapperEntity(
      flasks.map((e) => e.asEntity()).toList(), pageMeta.asEntity());
}
