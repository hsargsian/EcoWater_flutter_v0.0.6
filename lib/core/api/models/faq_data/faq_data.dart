import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/faq_entity/faq_entity.dart';

part 'faq_data.g.dart';

@JsonSerializable()
class FaqData {
  FaqData(
    this.id,
    this.title,
    this.body,
  );

  factory FaqData.fromJson(Map<String, dynamic> json) =>
      _$FaqDataFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String body;

  Map<String, dynamic> toJson() => _$FaqDataToJson(this);

  FaqEntity asEntity() => FaqEntity(id, title, body);
}
