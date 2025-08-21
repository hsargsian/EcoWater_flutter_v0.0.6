import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/week_one_traning_quote_domain.dart';

part 'week_one_traning_quote_entity.g.dart';

@JsonSerializable()
class WeekOneTraningQuoteEntity {
  WeekOneTraningQuoteEntity(
    this.testimony,
    this.author,
  );

  factory WeekOneTraningQuoteEntity.fromJson(Map<String, dynamic> json) =>
      _$WeekOneTraningQuoteEntityFromJson(json);

  final String testimony;
  final String author;

  Map<String, dynamic> toJson() => _$WeekOneTraningQuoteEntityToJson(this);
  WeekOneTraningQuoteDomain toDomain() => WeekOneTraningQuoteDomain(this);
}
