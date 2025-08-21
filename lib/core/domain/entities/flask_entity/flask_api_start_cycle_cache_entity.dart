import 'package:json_annotation/json_annotation.dart';

part 'flask_api_start_cycle_cache_entity.g.dart';

@JsonSerializable()
class FlaskApiStartCycleCacheEntity {
  FlaskApiStartCycleCacheEntity(
      this.uniqueIdentifier, this.flaskId, this.ppmValue);

  factory FlaskApiStartCycleCacheEntity.fromJson(Map<String, dynamic> json) =>
      _$FlaskApiStartCycleCacheEntityFromJson(json);

  final String uniqueIdentifier;
  final String flaskId;
  final double ppmValue;

  Map<String, dynamic> toJson() => _$FlaskApiStartCycleCacheEntityToJson(this);
}
