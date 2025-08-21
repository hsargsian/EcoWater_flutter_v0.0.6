import 'package:echowater/core/domain/domain_models/protocols_wrapper_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'protocol_entity.g.dart';

@JsonSerializable()
class ProtocolEntity {
  ProtocolEntity(
      this.id, this.title, this.description, this.url, this.isActive);

  factory ProtocolEntity.fromJson(Map<String, dynamic> json) =>
      _$ProtocolEntityFromJson(json);

  final String id;
  final String title;
  final String description;
  final String url;
  final bool isActive;

  Map<String, dynamic> toJson() => _$ProtocolEntityToJson(this);
  ProtocolDomain toDomain() => ProtocolDomain(this);
}
