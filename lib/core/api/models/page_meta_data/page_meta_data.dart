import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/page_meta_entity/page_meta_entity.dart';

part 'page_meta_data.g.dart';

@JsonSerializable()
class PageMetaData {
  PageMetaData(this.hasMore);

  factory PageMetaData.fromJson(Map<String, dynamic> json) =>
      _$PageMetaDataFromJson(json);
  @JsonKey(name: 'has_more')
  final bool hasMore;

  PageMetaEntity asEntity() => PageMetaEntity(hasMore);
}
