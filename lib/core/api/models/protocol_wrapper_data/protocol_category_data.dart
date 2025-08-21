import 'package:echowater/base/utils/strings.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/protocol_wrapper_entity/protocol_category_entity.dart';

part 'protocol_category_data.g.dart';

@JsonSerializable()
class ProtocolCategoryData {
  ProtocolCategoryData(this.name, this.id);

  factory ProtocolCategoryData.fromJson(Map<String, dynamic> json) =>
      _$ProtocolCategoryDataFromJson(json);

  final String name;
  final int id;

  Map<String, dynamic> toJson() => _$ProtocolCategoryDataToJson(this);

  ProtocolCategoryEntity asEntity() =>
      ProtocolCategoryEntity(name.capitalizeFirst(), name, id);
}
