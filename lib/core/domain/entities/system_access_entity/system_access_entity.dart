import 'package:json_annotation/json_annotation.dart';

part 'system_access_entity.g.dart';

@JsonSerializable()
class SystemAccessEntity {
  SystemAccessEntity(this.canAccessSystem, this.accessDate);

  factory SystemAccessEntity.fromJson(Map<String, dynamic> json) =>
      _$SystemAccessEntityFromJson(json);
  final bool canAccessSystem;
  final String accessDate;

  Map<String, dynamic> toJson() => _$SystemAccessEntityToJson(this);
}
