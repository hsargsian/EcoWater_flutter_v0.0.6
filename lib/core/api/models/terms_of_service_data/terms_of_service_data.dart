import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/terms_of_service_entity.dart';

part 'terms_of_service_data.g.dart';

@JsonSerializable()
class TermsOfServiceData {
  TermsOfServiceData(this.content);

  factory TermsOfServiceData.fromJson(Map<String, dynamic> json) =>
      _$TermsOfServiceDataFromJson(json);
  @JsonKey(name: 'terms_condition')
  final String content;

  Map<String, dynamic> toJson() => _$TermsOfServiceDataToJson(this);

  TermsOfServiceEntity asEntity() => TermsOfServiceEntity(content: content);
}
