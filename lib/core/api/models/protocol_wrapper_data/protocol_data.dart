import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/entities/protocol_wrapper_entity/protocol_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../base/utils/images.dart';

part 'protocol_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProtocolData {
  ProtocolData(this.id, this.title, this.category, this.image, this.isActive);

  factory ProtocolData.fromJson(Map<String, dynamic> json) => _$ProtocolDataFromJson(json);

  final int id;
  final String title;
  final String category;
  final String? image;
  final bool? isActive;

  Map<String, dynamic> toJson() => _$ProtocolDataToJson(this);

  ProtocolEntity asEntity() => ProtocolEntity(
        id.toString(),
        category.capitalizeFirst(),
        title,
        image ?? Images.defaultProtocolImage,
        isActive ?? false,
      );
}
