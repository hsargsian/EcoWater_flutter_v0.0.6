import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/protocol_category.dart';

part 'protocol_category_entity.g.dart';

@JsonSerializable()
class ProtocolCategoryEntity {
  ProtocolCategoryEntity(this.title, this.key, this.id);

  factory ProtocolCategoryEntity.fromJson(Map<String, dynamic> json) =>
      _$ProtocolCategoryEntityFromJson(json);

  final String title;
  final String key;
  final int id;
  Map<String, dynamic> toJson() => _$ProtocolCategoryEntityToJson(this);
  ProtocolCategoryDomain toDomain() => ProtocolCategoryDomain(this);
}
