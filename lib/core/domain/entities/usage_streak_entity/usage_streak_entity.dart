import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/usage_streak_domain.dart';

part 'usage_streak_entity.g.dart';

@JsonSerializable()
class UsageStreakEntity {
  UsageStreakEntity(this.usageStreak, this.longestStreakCount, this.totalBottles, this.totalPPMs, this.totalWaterConsumed);

  factory UsageStreakEntity.fromJson(Map<String, dynamic> json) => _$UsageStreakEntityFromJson(json);

  final int usageStreak;
  final int longestStreakCount;
  final num totalPPMs;
  final int totalBottles;
  final int totalWaterConsumed;

  Map<String, dynamic> toJson() => _$UsageStreakEntityToJson(this);

  UsageStreakDomain toDomain() => UsageStreakDomain(this);
}
