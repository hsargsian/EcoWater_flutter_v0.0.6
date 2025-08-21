import 'package:json_annotation/json_annotation.dart';

part 'api_success_message_response_entity.g.dart';

@JsonSerializable()
class ApiSuccessMessageResponseEntity {
  ApiSuccessMessageResponseEntity(this.message);
  factory ApiSuccessMessageResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$ApiSuccessMessageResponseEntityFromJson(json);

  final String message;
}
