import '../db/database_manager.dart';
import 'injector.dart';

class DatabaseModule {
  DatabaseModule._();

  static Future<void> init() async {
    Injector.instance.registerSingletonAsync<AppDatabaseManager>(() async {
      final databaseManager = AppDatabaseManager();
      await databaseManager.createDatabase();
      return databaseManager;
    });
  }
}
