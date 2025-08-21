import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';

part 'api_success_message_response.g.dart';

@JsonSerializable()
class ApiSuccessMessageResponse {
  ApiSuccessMessageResponse(this.message);
  factory ApiSuccessMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiSuccessMessageResponseFromJson(json);

  final String message;

  ApiSuccessMessageResponseEntity asEntity() =>
      ApiSuccessMessageResponseEntity(message);
}
