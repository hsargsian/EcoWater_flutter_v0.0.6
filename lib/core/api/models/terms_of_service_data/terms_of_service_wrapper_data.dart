import 'package:freezed_annotation/freezed_annotation.dart';

import 'terms_of_service_data.dart';
part 'terms_of_service_wrapper_data.g.dart';

@JsonSerializable()
class TermsOfServiceWrapperData {
  TermsOfServiceWrapperData(this.result);

  factory TermsOfServiceWrapperData.fromJson(Map<String, dynamic> json) =>
      _$TermsOfServiceWrapperDataFromJson(json);
  final List<TermsOfServiceData> result;
  Map<String, dynamic> toJson() => _$TermsOfServiceWrapperDataToJson(this);
}
