import 'package:echowater/core/domain/entities/todays_progress_entity/todays_progress_entity.dart';

class TodaysProgressDomain {
  TodaysProgressDomain(this._entity);

  final TodaysProgressEntity _entity;
  bool hasFetched = false;

  int get bottleConsumed => _entity.numberOfCycle;

  int get waterConsumed => _entity.waterCount ?? 0;

  num get ppmConsumed => _entity.ppmCount;

  int get bottleTotal => _entity.numberOfCycleTotal ?? 0;

  int get waterTotal => _entity.waterCountTotal ?? 0;

  int get ppmTotal => _entity.ppmCountTotal ?? 0;
}
