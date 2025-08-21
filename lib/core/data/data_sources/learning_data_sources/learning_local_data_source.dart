import 'package:echowater/core/domain/entities/learning_urls_entity/learning_urls_entity.dart';

import '../../../db/database_manager.dart';

abstract class LearningLocalDataSource {
  Future<List<LearningUrlsEntity>> fetchLearningBaseUrls();
}

class LearningLocalDataSourceImpl extends LearningLocalDataSource {
  LearningLocalDataSourceImpl({required AppDatabaseManager appDatabaseManager})
      : _appDatabaseManager = appDatabaseManager;
  late final AppDatabaseManager _appDatabaseManager;

  @override
  Future<List<LearningUrlsEntity>> fetchLearningBaseUrls() async {
    return [];
  }
}
