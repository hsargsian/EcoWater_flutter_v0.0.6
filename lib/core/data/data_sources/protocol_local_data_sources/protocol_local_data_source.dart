import 'package:echowater/core/domain/entities/protocol_wrapper_entity/protocol_entity.dart';

import '../../../db/database_manager.dart';

abstract class ProtocolLocalDataSource {
  Future<List<ProtocolEntity>> fetchProtocols();
}

class ProtocolLocalDataSourceImpl extends ProtocolLocalDataSource {
  ProtocolLocalDataSourceImpl({required AppDatabaseManager appDatabaseManager})
      : _appDatabaseManager = appDatabaseManager;
  late final AppDatabaseManager _appDatabaseManager;

  @override
  Future<List<ProtocolEntity>> fetchProtocols() async {
    return [];
  }
}
