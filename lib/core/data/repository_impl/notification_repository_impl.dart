import '../../api/exceptions/custom_exception.dart';
import '../../api/resource/resource.dart';
import '../../domain/entities/notification_entity/notification_count_entity.dart';
import '../../domain/entities/notification_entity/notification_wrapper_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/notification_data_sources/notification_local_datasource.dart';
import '../data_sources/notification_data_sources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(
      {required NotificationRemoteDataSource remoteDataSource,
      required NotificationLocalDataSource localDataSource})
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final NotificationRemoteDataSource _remoteDataSource;
  final NotificationLocalDataSource _localDataSource;

  @override
  Future<Result<NotificationWrapperEntity>> fetchNotifications(
      {required int offset, required int perPage}) async {
    try {
      final notificationsResponse = await _remoteDataSource.fetchNotifications(
          offset: offset, perPage: perPage);

      return Result.success(notificationsResponse.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> deleteNotification(
      {required String notificationId}) async {
    try {
      await _remoteDataSource.deleteNotification(
          notificationId: notificationId);

      return const Result.success(true);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<NotificationCountEntity>> fetchUnreadNotificationCount() async {
    try {
      final data = await _remoteDataSource.fetchUnreadNotificationsCount();

      return Result.success(data.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> readAllNotifications() async {
    try {
      await _remoteDataSource.readAllNotification();

      return const Result.success(true);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }
}
