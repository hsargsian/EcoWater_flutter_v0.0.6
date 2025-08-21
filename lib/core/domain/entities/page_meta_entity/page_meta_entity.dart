import 'package:json_annotation/json_annotation.dart';

part 'page_meta_entity.g.dart';

@JsonSerializable()
class PageMetaEntity {
  PageMetaEntity(this.hasMore);

  factory PageMetaEntity.fromJson(Map<String, dynamic> json) =>
      _$PageMetaEntityFromJson(json);

  final bool hasMore;

  Map<String, dynamic> toJson() => _$PageMetaEntityToJson(this);
}
