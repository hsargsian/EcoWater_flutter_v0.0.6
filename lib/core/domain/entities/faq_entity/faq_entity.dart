import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/faq_domain.dart';

part 'faq_entity.g.dart';

@JsonSerializable()
class FaqEntity {
  FaqEntity(
    this.id,
    this.question,
    this.answer,
  );

  factory FaqEntity.fromJson(Map<String, dynamic> json) =>
      _$FaqEntityFromJson(json);

  final String id;
  final String question;
  final String answer;

  Map<String, dynamic> toJson() => _$FaqEntityToJson(this);
  FaqDomain toDomain() => FaqDomain(this);
}
