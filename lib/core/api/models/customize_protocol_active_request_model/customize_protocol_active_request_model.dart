import 'package:json_annotation/json_annotation.dart';

part 'customize_protocol_active_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CustomizeProtocolActiveRequestModel {
  CustomizeProtocolActiveRequestModel({
    required this.protocolType,
    required this.protocolId,
    required this.updateGoals,
    required this.activate,
  });

  factory CustomizeProtocolActiveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CustomizeProtocolActiveRequestModelFromJson(json);
  final String protocolType;
  final int protocolId;
  final bool updateGoals;
  final bool activate;

  Map<String, dynamic> toJson() => _$CustomizeProtocolActiveRequestModelToJson(this);
}
