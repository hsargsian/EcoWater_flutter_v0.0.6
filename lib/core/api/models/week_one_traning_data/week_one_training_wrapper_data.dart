import 'package:echowater/core/api/models/week_one_traning_data/week_one_training_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'week_one_training_wrapper_data.g.dart';

@JsonSerializable()
class WeekOneTraningWrapperData {
  WeekOneTraningWrapperData(this.results);

  factory WeekOneTraningWrapperData.fromJson(Map<String, dynamic> json) =>
      _$WeekOneTraningWrapperDataFromJson(json);

  final List<WeekOneTraningData> results;

  Map<String, dynamic> toJson() => _$WeekOneTraningWrapperDataToJson(this);
}
