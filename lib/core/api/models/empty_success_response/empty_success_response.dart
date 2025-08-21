import 'package:json_annotation/json_annotation.dart';

part 'empty_success_response.g.dart';

@JsonSerializable()
class EmptySuccessResponse {
  EmptySuccessResponse();
  factory EmptySuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$EmptySuccessResponseFromJson(json);
}
