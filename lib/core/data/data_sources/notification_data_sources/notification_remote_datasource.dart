import 'package:dio/dio.dart';
import 'package:echowater/core/api/models/notification_data/notification_count_data.dart';
import 'package:flutter/foundation.dart';

import '../../../api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../../../api/exceptions/exception_handler.dart';
import '../../../api/models/empty_success_response/empty_success_response.dart';
import '../../../api/models/notifications_data_wrapper/notifications_data_wrapper.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationsDataWrapper> fetchNotifications(
      {required int offset, required int perPage});
  Future<EmptySuccessResponse> deleteNotification(
      {required String notificationId});
  Future<EmptySuccessResponse> readAllNotification();
  Future<NotificationCountData> fetchUnreadNotificationsCount();
}

class NotificationRemoteDataSourceImpl extends NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl(
      {required AuthorizedApiClient authorizedApiClient})
      : _authorizedApiClient = authorizedApiClient;

  final AuthorizedApiClient _authorizedApiClient;

  CancelToken _fetchNotificationsCancelToken = CancelToken();

  @override
  Future<NotificationsDataWrapper> fetchNotifications(
      {required int offset, required int perPage}) async {
    try {
      _fetchNotificationsCancelToken.cancel();
      _fetchNotificationsCancelToken = CancelToken();
      return await _authorizedApiClient.fetchNotifications(offset, perPage);
    } catch (e) {
      if (kDebugMode) {
        print('Error message $e');
      }
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<EmptySuccessResponse> deleteNotification(
      {required String notificationId}) async {
    try {
      await _authorizedApiClient.deleteNotification(notificationId);
      return Future.value(EmptySuccessResponse());
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<NotificationCountData> fetchUnreadNotificationsCount() async {
    try {
      final data = await _authorizedApiClient.fetchUnreadNotificationsCount();
      return Future.value(data);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<EmptySuccessResponse> readAllNotification() async {
    try {
      await _authorizedApiClient.readUnReadNotiifications();
      return Future.value(EmptySuccessResponse());
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
