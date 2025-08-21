import 'package:echowater/core/domain/domain_models/todays_progress_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todays_progress_entity.g.dart';

@JsonSerializable()
class TodaysProgressEntity {
  TodaysProgressEntity(
      this.numberOfCycle, this.ppmCount, this.waterCount, this.numberOfCycleTotal, this.ppmCountTotal, this.waterCountTotal);

  factory TodaysProgressEntity.fromJson(Map<String, dynamic> json) => _$TodaysProgressEntityFromJson(json);

  final int numberOfCycle;
  final num ppmCount;
  final int? waterCount;

  final int? numberOfCycleTotal;
  final int? ppmCountTotal;
  final int? waterCountTotal;

  Map<String, dynamic> toJson() => _$TodaysProgressEntityToJson(this);

  TodaysProgressDomain toDomain() => TodaysProgressDomain(this);
}
