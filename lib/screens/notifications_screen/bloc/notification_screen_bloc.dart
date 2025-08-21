import 'package:bloc/bloc.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';

import '../../../core/domain/domain_models/fetch_style.dart';
import '../../../core/domain/domain_models/notification_domain.dart';
import '../../../core/domain/domain_models/notification_wrapper_domain.dart';
import '../../../core/domain/repositories/notification_repository.dart';
import '../../../core/domain/repositories/user_repository.dart';
import '../../../core/injector/injector.dart';
import '../../auth/authentication/bloc/authentication_bloc.dart';

part 'notification_screen_event.dart';
part 'notification_screen_state.dart';

class NotificationScreenBloc
    extends Bloc<NotificationScreenEvent, NotificationScreenState> {
  NotificationScreenBloc(
      {required NotificationRepository notificationRepository,
      required UserRepository userRepository})
      : _notificationRepository = notificationRepository,
        _userRepository = userRepository,
        super(NotificationScreenIdleState()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<ReadAllNotificationEvent>(_onReadAllNotifications);
    on<DeleteNotificationEvent>(_onDeleteNotification);
  }
  final NotificationRepository _notificationRepository;
  final UserRepository _userRepository;

  NotificationWrapperDomain notificationsWrapper = NotificationWrapperDomain(
    true,
    [],
  );

  Future<void> _onDeleteNotification(
    DeleteNotificationEvent event,
    Emitter<NotificationScreenState> emit,
  ) async {
    // final response = await _notificationRepository.deleteNotification(
    //     notificationId: event.notification.id);
    // response.when(success: (success) {
    //   // notificationsWrapper.remove(notification: event.notification);
    //   emit(FetchedNotificationsState());
    // }, error: (error) {
    //   emit(FetchedNotificationsState());
    //   emit(NotificationScreenApiErrorState(error.toMessage()));
    // });
  }

  Future<void> _onReadAllNotifications(
    ReadAllNotificationEvent event,
    Emitter<NotificationScreenState> emit,
  ) async {
    await _notificationRepository.readAllNotifications();
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationScreenState> emit,
  ) async {
    final currentUser = await _userRepository.getCurrentUserId();
    if (currentUser == null) {
      emit(NotificationScreenApiErrorState(
          'user_session_expired_message'.localized));
      Injector.instance<AuthenticationBloc>().add(
          ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      return;
    }

    var offset = 0;
    switch (event.fetchStyle) {
      case FetchStyle.normal:
        emit(FetchingNotificationsState());
        notificationsWrapper = NotificationWrapperDomain(
          true,
          [],
        );
      case FetchStyle.pullToRefresh:
        notificationsWrapper = NotificationWrapperDomain(
          true,
          [],
        );
      case FetchStyle.loadMore:
        offset = notificationsWrapper.notifications.length;
    }
    final response = await _notificationRepository.fetchNotifications(
        offset: offset, perPage: 20);
    response.when(success: (notificationsResponse) {
      switch (event.fetchStyle) {
        case FetchStyle.normal:
        case FetchStyle.pullToRefresh:
          notificationsWrapper = notificationsResponse.toDomain();
        case FetchStyle.loadMore:
          notificationsWrapper.hasMore = notificationsResponse.pageMeta.hasMore;
          notificationsWrapper.notifications.addAll(notificationsResponse
              .notifications
              .map((e) => e.toDomain())
              .toList());
      }

      emit(FetchedNotificationsState());
    }, error: (error) {
      emit(NotificationScreenApiErrorState(error.toMessage()));
    });
  }
}
