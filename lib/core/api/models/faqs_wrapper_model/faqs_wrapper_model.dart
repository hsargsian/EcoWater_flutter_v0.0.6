import 'package:json_annotation/json_annotation.dart';

import '../faq_data/faq_data.dart';

part 'faqs_wrapper_model.g.dart';

@JsonSerializable()
class FaqsWrapperData {
  FaqsWrapperData(this.faqs);

  factory FaqsWrapperData.fromJson(Map<String, dynamic> json) =>
      _$FaqsWrapperDataFromJson(json);
  @JsonKey(name: 'result')
  final List<FaqData> faqs;
}
