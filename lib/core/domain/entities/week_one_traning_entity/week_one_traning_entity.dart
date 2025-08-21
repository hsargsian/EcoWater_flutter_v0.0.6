import 'package:echowater/core/domain/entities/week_one_traning_entity/week_one_traning_quote_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/week_one_traning_domain.dart';

part 'week_one_traning_entity.g.dart';

@JsonSerializable()
class WeekOneTraningEntity {
  WeekOneTraningEntity(this.day, this.tagTitle, this.image, this.title,
      this.description, this.checkItems, this.subDesctiption, this.quotes);

  factory WeekOneTraningEntity.fromJson(Map<String, dynamic> json) =>
      _$WeekOneTraningEntityFromJson(json);

  final int day;
  final String tagTitle;
  final String? image;
  final String? title;
  final String? description;
  final List<String>? checkItems;
  final String? subDesctiption;
  final List<WeekOneTraningQuoteEntity>? quotes;

  Map<String, dynamic> toJson() => _$WeekOneTraningEntityToJson(this);
  WeekOneTraningDomain toDomain() => WeekOneTraningDomain(this);
}
