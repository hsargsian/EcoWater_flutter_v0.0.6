import 'package:echowater/core/domain/entities/usage_dates_entity/usage_dates_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usage_dates_data.g.dart';

@JsonSerializable()
class UsageDatesData {
  UsageDatesData(this.dates);

  factory UsageDatesData.fromJson(Map<String, dynamic> json) =>
      _$UsageDatesDataFromJson(json);

  @JsonKey(name: 'usage-dates')
  final List<String> dates;

  Map<String, dynamic> toJson() => _$UsageDatesDataToJson(this);

  UsageDatesEntity asEntity() => UsageDatesEntity(dates);
}
