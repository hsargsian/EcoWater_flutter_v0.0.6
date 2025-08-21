import 'package:echowater/core/domain/entities/week_one_traning_entity/week_one_traning_entity.dart';

import '../../../db/database_manager.dart';

abstract class GoalsAndStatsLocalDataSource {
  Future<List<WeekOneTraningEntity>> fetchWeekOneTraningSet();
}

class GoalsAndStatsLocalDataSourceImpl extends GoalsAndStatsLocalDataSource {
  GoalsAndStatsLocalDataSourceImpl(
      {required AppDatabaseManager appDatabaseManager})
      : _appDatabaseManager = appDatabaseManager;
  late final AppDatabaseManager _appDatabaseManager;

  @override
  Future<List<WeekOneTraningEntity>> fetchWeekOneTraningSet() async {
    return [];
  }
}
