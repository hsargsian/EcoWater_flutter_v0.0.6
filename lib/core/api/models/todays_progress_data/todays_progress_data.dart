import 'package:echowater/core/domain/entities/todays_progress_entity/todays_progress_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todays_progress_data.g.dart';

@JsonSerializable()
class TodaysProgressData {
  TodaysProgressData(this.numberOfCycle, this.ppmCount, this.numberOfCycleTotal, this.ppmCountTotal, this.amountOfWater,
      this.amountOfWaterTotal);

  factory TodaysProgressData.fromJson(Map<String, dynamic> json) => _$TodaysProgressDataFromJson(json);

  @JsonKey(name: 'number_of_cycle')
  final int numberOfCycle;

  @JsonKey(name: 'hydrogen_count')
  final num ppmCount;

  @JsonKey(name: 'total_number_of_cycle')
  final int? numberOfCycleTotal;

  @JsonKey(name: 'total_hydrogen_count')
  final int? ppmCountTotal;

  @JsonKey(name: 'water_amount')
  final int? amountOfWater;

  @JsonKey(name: 'total_water_amount')
  final int? amountOfWaterTotal;

  Map<String, dynamic> toJson() => _$TodaysProgressDataToJson(this);

  TodaysProgressEntity asEntity() =>
      TodaysProgressEntity(numberOfCycle, ppmCount, amountOfWater, numberOfCycleTotal, ppmCountTotal, amountOfWaterTotal);
}
