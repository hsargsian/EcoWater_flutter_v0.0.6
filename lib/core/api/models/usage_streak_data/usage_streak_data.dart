import 'package:echowater/core/domain/entities/usage_streak_entity/usage_streak_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usage_streak_data.g.dart';

@JsonSerializable()
class UsageStreakData {
  UsageStreakData(this.streakCount, this.longestStreakCount, this.totalPPMsCount, this.totalBottlesCount, this.totalWaterCount);

  factory UsageStreakData.fromJson(Map<String, dynamic> json) => _$UsageStreakDataFromJson(json);

  @JsonKey(name: 'current_streak')
  final int streakCount;

  @JsonKey(name: 'longest_streak')
  final int? longestStreakCount;

  @JsonKey(name: 'total_hydrogen_consumed')
  final num? totalPPMsCount;

  @JsonKey(name: 'total_bottle_consumed')
  final int? totalBottlesCount;

  @JsonKey(name: 'total_water_consumed')
  final int? totalWaterCount;

  Map<String, dynamic> toJson() => _$UsageStreakDataToJson(this);

  UsageStreakEntity asEntity() =>
      UsageStreakEntity(streakCount, longestStreakCount ?? 0, totalBottlesCount ?? 0, totalPPMsCount ?? 0, totalWaterCount ?? 0);
}
