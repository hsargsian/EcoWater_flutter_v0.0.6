import 'package:echowater/core/domain/entities/flask_entity/flask_entity.dart';

import '../../../db/database_manager.dart';
import '../../../domain/entities/flask_entity/flask_api_start_cycle_cache_entity.dart';

abstract class FlaskLocalDataSource {
  Future<List<FlaskEntity>> getFlasks();
  Future<List<FlaskApiStartCycleCacheEntity>> getFlaskStartCycleCache();
}

class FlaskLocalDataSourceImpl extends FlaskLocalDataSource {
  FlaskLocalDataSourceImpl({required AppDatabaseManager appDatabaseManager})
      : _appDatabaseManager = appDatabaseManager;

  late final AppDatabaseManager _appDatabaseManager;

  @override
  Future<List<FlaskEntity>> getFlasks() async {
    return [];
  }

  @override
  Future<List<FlaskApiStartCycleCacheEntity>> getFlaskStartCycleCache() async {
    return [];
  }
}
