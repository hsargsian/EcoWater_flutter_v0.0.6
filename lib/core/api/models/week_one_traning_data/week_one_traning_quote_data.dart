import 'package:echowater/core/domain/entities/week_one_traning_entity/week_one_traning_quote_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'week_one_traning_quote_data.g.dart';

@JsonSerializable()
class WeekOneTraningQuoteData {
  WeekOneTraningQuoteData(
    this.testimony,
    this.author,
  );

  WeekOneTraningQuoteData.dummy({int index = 1})
      : testimony = 'Testimony $index',
        author = 'Author $index';

  factory WeekOneTraningQuoteData.fromJson(Map<String, dynamic> json) =>
      _$WeekOneTraningQuoteDataFromJson(json);

  final String testimony;
  final String author;

  Map<String, dynamic> toJson() => _$WeekOneTraningQuoteDataToJson(this);
  WeekOneTraningQuoteEntity asEntity() =>
      WeekOneTraningQuoteEntity(testimony, author);

  static List<WeekOneTraningQuoteData> getDummyQuotes({int length = 5}) {
    return List.generate(length, (index) {
      return WeekOneTraningQuoteData.dummy(index: index);
    });
  }
}
