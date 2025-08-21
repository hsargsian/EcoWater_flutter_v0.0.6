import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/walk_through_progress_domain.dart';

part 'walk_through_progress_entity.g.dart';

@JsonSerializable()
class WalkThroughProgressEntity {
  WalkThroughProgressEntity(
      this.hasSeenHomeScreenWalkThrough,
      this.hasSeenGoalScreenWalkThrough,
      this.hasSeenLearningScreenWalkThrough,
      this.hasSeenProfileScreenWalkThrough);

  factory WalkThroughProgressEntity.fromJson(Map<String, dynamic> json) =>
      _$WalkThroughProgressEntityFromJson(json);

  bool hasSeenHomeScreenWalkThrough;
  bool hasSeenGoalScreenWalkThrough;
  bool hasSeenLearningScreenWalkThrough;
  bool hasSeenProfileScreenWalkThrough;

  Map<String, dynamic> toJson() => _$WalkThroughProgressEntityToJson(this);
  WalkThroughProgressDomain toDomain() => WalkThroughProgressDomain(this);
}
