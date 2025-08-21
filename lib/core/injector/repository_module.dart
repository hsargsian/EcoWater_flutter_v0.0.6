import 'package:echowater/core/data/repository_impl/flask_repository_impl.dart';
import 'package:echowater/core/data/repository_impl/goals_and_stats_repository_impl.dart';
import 'package:echowater/core/data/repository_impl/protocol_repository_impl.dart';
import 'package:echowater/core/domain/repositories/flask_repository.dart';
import 'package:echowater/core/domain/repositories/friends_repository.dart';
import 'package:echowater/core/domain/repositories/goals_and_stats_repository.dart';
import 'package:echowater/core/domain/repositories/learning_repository.dart';
import 'package:echowater/core/domain/repositories/protocol_repository.dart';

import '../data/repository_impl/asset_repository_impl.dart';
import '../data/repository_impl/auth_repository_impl.dart';
import '../data/repository_impl/device_repository_impl.dart';
import '../data/repository_impl/friends_repository_impl.dart';
import '../data/repository_impl/learning_repository_impl.dart';
import '../data/repository_impl/notification_repository_impl.dart';
import '../data/repository_impl/other_repository_impl.dart';
import '../data/repository_impl/user_repository_impl.dart';
import '../domain/repositories/asset_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/device_repository.dart';
import '../domain/repositories/notification_repository.dart';
import '../domain/repositories/other_repository.dart';
import '../domain/repositories/user_repository.dart';
import 'injector.dart';

class RepositoryModule {
  RepositoryModule._();

  static void init() {
    final injector = Injector.instance;

    injector
      ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(
            remoteDataSource: injector(), localDataSource: injector()),
      )
      ..registerFactory<UserRepository>(
        () => UserRepositoryImpl(
            remoteDataSource: injector(), localDataSource: injector()),
      )
      ..registerFactory<OtherRepository>(
        () => OtherRepositoryImpl(
            remoteDataSource: injector(), localDataSource: injector()),
      )
      ..registerFactory<NotificationRepository>(
        () => NotificationRepositoryImpl(
            remoteDataSource: injector(), localDataSource: injector()),
      )
      ..registerFactory<DeviceRepository>(
        () => DeviceRepositoryImpl(
            remoteDataSource: injector(), localDataSource: injector()),
      )
      ..registerFactory<AssetRepository>(
        () => AssetRepositoryImpl(remoteDataSource: injector()),
      )
      ..registerFactory<FlaskRepository>(
        () => FlaskRepositoryImpl(
            remoteDataSource: injector(),
            localDataSource: injector(),
            marketingPushService: injector(),
            cacheAndRetryService: injector()),
      )
      ..registerFactory<LearningRepository>(
        () => LearningRepositoryImpl(
            remoteDataSource: injector(), localDataSource: injector()),
      )
      ..registerFactory<GoalsAndStatsRepository>(
        () => GoalsAndStatsRepositoryImpl(
            remoteDataSource: injector(), localDataSource: injector()),
      )
      ..registerFactory<FriendsRepository>(
        () => FriendsRepositoryImpl(
            remoteDataSource: injector(), localDataSource: injector()),
      )
      ..registerFactory<ProtocolRepository>(
        () => ProtocolRepositoryImpl(
            remoteDataSource: injector(), localDataSource: injector()),
      );
  }
}
