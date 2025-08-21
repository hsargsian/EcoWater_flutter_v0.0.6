import 'package:echowater/core/domain/entities/week_one_traning_entity/week_one_traning_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'week_one_traning_quote_data.dart';

part 'week_one_training_data.g.dart';

@JsonSerializable()
class WeekOneTraningData {
  WeekOneTraningData(this.id, this.day, this.tagTitle, this.image, this.title,
      this.description, this.checkItems, this.subDesctiption, this.quotes);

  factory WeekOneTraningData.fromJson(Map<String, dynamic> json) =>
      _$WeekOneTraningDataFromJson(json);

  final int id;
  final int day;
  @JsonKey(name: 'tag_title')
  final String tagTitle;
  final String? image;
  final String? title;
  final String? description;
  @JsonKey(name: 'check_items')
  final List<String>? checkItems;
  @JsonKey(name: 'sub_description')
  final String? subDesctiption;
  final List<WeekOneTraningQuoteData>? quotes;

  Map<String, dynamic> toJson() => _$WeekOneTraningDataToJson(this);
  WeekOneTraningEntity asEntity() => WeekOneTraningEntity(
      day,
      tagTitle,
      image,
      title,
      description,
      checkItems,
      subDesctiption,
      (quotes ?? []).map((e) => e.asEntity()).toList());
}
