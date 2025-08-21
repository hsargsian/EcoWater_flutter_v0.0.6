import 'package:echowater/core/domain/entities/walk_through_progress_entity/walk_through_progress_entity.dart';

class WalkThroughProgressDomain {
  const WalkThroughProgressDomain(this._entity);
  WalkThroughProgressDomain.dummy()
      : _entity = WalkThroughProgressEntity(true, true, true, true);
  final WalkThroughProgressEntity _entity;

  bool get hasSeenHomeScreenWalkThrough => _entity.hasSeenHomeScreenWalkThrough;
  bool get hasSeenGoalScreenWalkThrough => _entity.hasSeenGoalScreenWalkThrough;
  bool get hasSeenLearningScreenWalkThrough =>
      _entity.hasSeenLearningScreenWalkThrough;
  bool get hasSeenProfileScreenWalkThrough =>
      _entity.hasSeenProfileScreenWalkThrough;

  bool updateSeenHomeWalkThrough({bool flag = true}) =>
      _entity.hasSeenHomeScreenWalkThrough = flag;

  bool updateSeenGoalWalkThrough({bool flag = true}) =>
      _entity.hasSeenGoalScreenWalkThrough = flag;

  bool updateSeenLearningWalkThrough({bool flag = true}) =>
      _entity.hasSeenLearningScreenWalkThrough = flag;

  bool updateSeenProfileWalkThrough({bool flag = true}) =>
      _entity.hasSeenProfileScreenWalkThrough = flag;

  bool get isTooltipEnabled =>
      !hasSeenHomeScreenWalkThrough ||
      !hasSeenGoalScreenWalkThrough ||
      !hasSeenLearningScreenWalkThrough ||
      !hasSeenProfileScreenWalkThrough;
}
