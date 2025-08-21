import 'package:echowater/core/data/data_sources/flask_data_sources/flask_local_data_source.dart';
import 'package:echowater/core/data/data_sources/flask_data_sources/flask_remote_data_source.dart';
import 'package:echowater/core/data/data_sources/friends_data_sources/friends_local_data_source.dart';
import 'package:echowater/core/data/data_sources/friends_data_sources/friends_remote_data_source.dart';
import 'package:echowater/core/data/data_sources/goals_and_stats_data_sources/goals_and_stats_local_data_source.dart';
import 'package:echowater/core/data/data_sources/goals_and_stats_data_sources/goals_and_stats_remote_data_source.dart';
import 'package:echowater/core/data/data_sources/learning_data_sources/learning_local_data_source.dart';
import 'package:echowater/core/data/data_sources/learning_data_sources/learning_remote_data_source.dart';

import '../data/data_sources/asset_data_sources/asset_remote_datasource.dart';
import '../data/data_sources/auth_data_sources/auth_local_datasource.dart';
import '../data/data_sources/auth_data_sources/auth_remote_datasource.dart';
import '../data/data_sources/device_data_sources/device_local_data_source.dart';
import '../data/data_sources/device_data_sources/device_remote_data_source.dart';
import '../data/data_sources/notification_data_sources/notification_local_datasource.dart';
import '../data/data_sources/notification_data_sources/notification_remote_datasource.dart';
import '../data/data_sources/other_data_sources/other_local_datasource.dart';
import '../data/data_sources/other_data_sources/other_remote_datasource.dart';
import '../data/data_sources/protocol_local_data_sources/protocol_local_data_source.dart';
import '../data/data_sources/protocol_local_data_sources/protocol_remote_data_source.dart';
import '../data/data_sources/user_data_sources/user_local_datasource.dart';
import '../data/data_sources/user_data_sources/user_remote_datasource.dart';
import 'injector.dart';

class DataSourceModule {
  DataSourceModule._();

  static void init() {
    final injector = Injector.instance;

    injector
      ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(authApiClient: injector()),
      )
      ..registerFactory<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(localStorageService: injector()),
      )
      ..registerFactory<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(
            appDatabaseManager: injector(),
            localStorageService: injector(),
            marketingPushService: injector()),
      )
      ..registerFactory<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(userApiClient: injector()),
      )
      ..registerFactory<OtherRemoteDataSource>(
        () => OtherRemoteDataSourceImpl(
            authApiClient: injector(), authorizedApiClient: injector()),
      )
      ..registerFactory<OtherLocalDataSource>(
        OtherLocalDataSourceImpl.new,
      )
      ..registerFactory<NotificationRemoteDataSource>(
        () => NotificationRemoteDataSourceImpl(authorizedApiClient: injector()),
      )
      ..registerFactory<NotificationLocalDataSource>(
        () => NotificationLocalDataSourceImpl(appDatabaseManager: injector()),
      )
      ..registerFactory<DeviceRemoteDataSource>(
        () => DeviceRemoteDataSourceImpl(userApiClient: injector()),
      )
      ..registerFactory<DeviceLocalDataSource>(
        () => DeviceLocalDataSourceImpl(localStorageService: injector()),
      )
      ..registerFactory<AssetRemoteDataSource>(
        () => AssetRemoteDataSourceImpl(userApiClient: injector()),
      )
      ..registerFactory<FlaskRemoteDataSource>(
        () => FlaskRemoteDataSourceImpl(authorizedApiClient: injector()),
      )
      ..registerFactory<FlaskLocalDataSource>(
        () => FlaskLocalDataSourceImpl(
          appDatabaseManager: injector(),
        ),
      )
      ..registerFactory<LearningRemoteDataSource>(
        () => LearningRemoteDataSourceImpl(authorizedApiClient: injector()),
      )
      ..registerFactory<LearningLocalDataSource>(
        () => LearningLocalDataSourceImpl(appDatabaseManager: injector()),
      )
      ..registerFactory<GoalsAndStatsRemoteDataSource>(
        () =>
            GoalsAndStatsRemoteDataSourceImpl(authorizedApiClient: injector()),
      )
      ..registerFactory<GoalsAndStatsLocalDataSource>(
        () => GoalsAndStatsLocalDataSourceImpl(appDatabaseManager: injector()),
      )
      ..registerFactory<FriendsLocalDataSource>(
        () => FriendsLocalDataSourceImpl(appDatabaseManager: injector()),
      )
      ..registerFactory<FriendsRemoteDataSource>(
        () => FriendsRemoteDataSourceImpl(authorizedApiClient: injector()),
      )
      ..registerFactory<ProtocolLocalDataSource>(
        () => ProtocolLocalDataSourceImpl(appDatabaseManager: injector()),
      )
      ..registerFactory<ProtocolRemoteDataSource>(
        () => ProtocolRemoteDataSourceImpl(authorizedApiClient: injector()),
      );
  }
}
