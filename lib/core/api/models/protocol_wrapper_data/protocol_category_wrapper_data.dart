import 'package:echowater/core/api/models/protocol_wrapper_data/protocol_category_data.dart';
import 'package:json_annotation/json_annotation.dart';

import '../page_meta_data/page_meta_data.dart';

part 'protocol_category_wrapper_data.g.dart';

@JsonSerializable()
class ProtocolCategoryWrapperData {
  ProtocolCategoryWrapperData(this.protocols, this.pageMeta);

  factory ProtocolCategoryWrapperData.fromJson(Map<String, dynamic> json) =>
      _$ProtocolCategoryWrapperDataFromJson(json);

  @JsonKey(name: 'results')
  List<ProtocolCategoryData> protocols;
  @JsonKey(name: 'meta')
  final PageMetaData pageMeta;
}
