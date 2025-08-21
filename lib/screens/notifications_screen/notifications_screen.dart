import 'package:echowater/base/app_specific_widgets/friend_requests_notification_view.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/notification_type.dart';
import 'package:echowater/core/services/crashlytics_service/crashlytics_service.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base/app_specific_widgets/app_boxed_container.dart';
import '../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../base/common_widgets/empty_state_view.dart';
import '../../base/common_widgets/image_widgets/app_image_view.dart';
import '../../base/common_widgets/loader/loader.dart';
import '../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../base/common_widgets/navbar/nav_bar.dart';
import '../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../base/utils/colors.dart';
import '../../base/utils/images.dart';
import '../../base/utils/utilities.dart';
import '../../core/domain/domain_models/fetch_style.dart';
import '../../core/domain/domain_models/notification_domain.dart';
import '../../core/injector/injector.dart';
import '../friends/friend_request_listing_view/bloc/friend_request_listing_view_bloc.dart';
import '../friends/friend_request_listing_view/friend_request.dart';
import '../friends/friend_request_listing_view/friend_request_listing_view.dart';
import 'bloc/notification_screen_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({this.onRefetchNotificationCount, super.key});

  final Function()? onRefetchNotificationCount;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();

  static Route<void> route({Function()? onRefetchNotificationCount}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/NotificationsScreen'),
        builder: (_) => NotificationsScreen(onRefetchNotificationCount: onRefetchNotificationCount));
  }
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationScreenBloc _bloc;
  late final FriendRequestsListingViewBloc _friendRequestsListingViewBloc;

  final _refreshController = RefreshController();

  @override
  void initState() {
    _bloc = Injector.instance<NotificationScreenBloc>();
    _friendRequestsListingViewBloc = Injector.instance<FriendRequestsListingViewBloc>();
    super.initState();
    _bloc.add(FetchNotificationsEvent(FetchStyle.normal));
    _friendRequestsListingViewBloc.add(FetchFriendRequestsEvent(FetchStyle.normal));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EchoWaterNavBar(
            child: NavBar(
                navStyle: NavStyle.singleLined,
                navTitle: 'Notifications_Screen_title'.localized,
                textColor: Theme.of(context).colorScheme.primaryElementColor,
                leftButton: LeftArrowBackButton(
                  onButtonPressed: () {
                    _bloc.add(ReadAllNotificationEvent());
                    widget.onRefetchNotificationCount?.call();
                    Navigator.pop(context);
                  },
                ),
                sideMenuItems: const [])),
        body: Column(
          children: [
            _friendRequestView(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: BlocConsumer<NotificationScreenBloc, NotificationScreenState>(
                bloc: _bloc,
                listener: (context, state) {
                  _onStateChanged(state);
                },
                builder: (context, state) {
                  return state is FetchingNotificationsState
                      ? const Center(child: Loader())
                      : state is FetchedNotificationsState
                          ? _mainContent()
                          : const SizedBox.shrink();
                },
              ),
            ),
          ],
        ));
  }

  Widget _mainContent() {
    if (_bloc.notificationsWrapper.notifications.isEmpty) {
      return Center(
        child: EmptyStateView(
          title: 'Notifications_Screen_no_notifications'.localized,
          tags: const [],
        ),
      );
    } else {
      return AppBoxedContainer(
        borderSides: const [AppBorderSide.bottom, AppBorderSide.top],
        child: SmartRefresher(
          controller: _refreshController,
          enablePullUp: _bloc.notificationsWrapper.hasMore,
          onLoading: () async {
            await Utilities.vibrate();
            _bloc.add(FetchNotificationsEvent(FetchStyle.loadMore));
          },
          onRefresh: () async {
            await Utilities.vibrate();
            _bloc.add(FetchNotificationsEvent(FetchStyle.pullToRefresh));
            _friendRequestsListingViewBloc.add(FetchFriendRequestsEvent(FetchStyle.normal));
          },
          child: _historyView(),
        ),
      );
    }
  }

  Widget _friendRequestView() {
    return BlocConsumer<FriendRequestsListingViewBloc, FriendRequestListingViewState>(
        bloc: _friendRequestsListingViewBloc,
        listener: (context, state) {
          _onFriendStateChanged(state, context);
        },
        builder: (context, state) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  FriendRequestListingView.route(
                      isSubSectionView: false,
                      onRequestStatusChanged: () {
                        _friendRequestsListingViewBloc.add(FetchFriendRequestsEvent(FetchStyle.normal));
                        _bloc.add(FetchNotificationsEvent(FetchStyle.normal));
                      }));
            },
            child: FriendRequestsNotificationView(requestsWrapper: _friendRequestsListingViewBloc.friendRequestWrapper),
          );
        });
  }

  Widget _historyView() {
    return ListView.builder(
        itemCount: _bloc.notificationsWrapper.notifications.length,
        itemBuilder: (context, index) {
          final item = _bloc.notificationsWrapper.notifications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: _handleNotificationType(item),
                ),
                Visibility(
                  visible: !item.isRead,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _onStateChanged(NotificationScreenState state) {
    if (state is NotificationScreenApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is FetchedNotificationsState) {
      _refreshController
        ..loadComplete()
        ..refreshCompleted();
    }
  }

  Widget _goalCompletionWidget(NotificationDomain notification) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Center(
                child: SvgPicture.asset(
                  Images.goalCompletion,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.message),
                Text(notification.humanReadableCreatedDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.colorB3B3B3)),
              ],
            ))
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _teamGoalCreationCompletionAndReminder(NotificationDomain notification) {
    return Column(
      children: [
        Row(
          children: [
            AppImageView(
              avatarUrl: notification.firstImage,
              width: 50,
              height: 50,
              cornerRadius: 8,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(data: notification.message),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(notification.humanReadableCreatedDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.colorB3B3B3)),
                ),
              ],
            ))
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _friendRequestAccepted(NotificationDomain notification) {
    return InkWell(
      onTap: () {
        final friendId = notification.friendRequestFriendId;
        final error = 'Notification of type ${notification.notificationType.key}'
            " didn't have freidndRequest friend id in custom data";
        if (friendId != null) {
          Injector.instance<CrashlyticsService>().recordError(error, null, information: ['notification id: ${notification.id}']);
          return;
        }
        //Navigator.push(context, FriendsProfileScreen.route(friendId));
      },
      child: Column(
        children: [
          Row(
            children: [
              AppImageView(
                avatarUrl: notification.firstImage,
                width: 50,
                height: 50,
                cornerRadius: 8,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(child: Html(data: notification.message))
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _promotionalArticleVideo(NotificationDomain notification) {
    var promotionalType = 'Watch now>';
    if (notification.isPromotionalNotification) {
      promotionalType = 'Read now>';
    }
    return InkWell(
      onTap: () {
        if (notification.externalUrl != null) {
          Utilities.launchUrl(notification.externalUrl!);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppImageView(
                avatarUrl: notification.imageUrl,
                width: 50,
                height: 50,
                cornerRadius: 8,
              ),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Html(data: notification.message),
                    Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Text(notification.createdDate(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.colorB3B3B3)),
                        const Spacer(),
                        Text(promotionalType,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.colorB3B3B3))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _handleNotificationType(NotificationDomain notification) {
    final notificationType = notification.notificationType;
    switch (notificationType) {
      case NotificationType.personalHydrogenGoalCompletion:
      case NotificationType.personalBottleGoalCompletion:
      case NotificationType.personalWaterGoalCompletion:
        return _goalCompletionWidget(notification);
      case NotificationType.teamGoalCreation:
      case NotificationType.teamBottleGoalCompletion:
      case NotificationType.teamWaterGoalCompletion:
      case NotificationType.teamBottleGoalCompletionByFriend:
      case NotificationType.teamHydrogenGoalCompletionByFriend:
      case NotificationType.teamWaterGoalCompletionByFriend:
      case NotificationType.teamHydrogenGoalCompletion:
      case NotificationType.friendReminder:
      case NotificationType.cleanFlaskReminder:
      case NotificationType.teamGoalRemoval:
      case NotificationType.teamGoalUpdate:
      case NotificationType.appSetupCompletion:
      case NotificationType.trainingReminder:
      case NotificationType.trainingCompletedReminder:
      case NotificationType.usageStreakCompletedReminder:
      case NotificationType.flaskCycleCompletion:
      case NotificationType.friendGoalStreakCompletedReminder:
      case NotificationType.dailyHydrationReminder:
      case NotificationType.articleNotificationReminder:
      case NotificationType.goalStreakCompletion:
      case NotificationType.protocolNotification:
        return _teamGoalCreationCompletionAndReminder(notification);

      case NotificationType.friendRequestCreated:
        final requestDomain = notification.getFriendRequestForNotification();
        if (requestDomain == null) {
          return const SizedBox.shrink();
        }
        return FriendRequest(
          requestDomain,
          acceptRequest: (model) {
            _friendRequestsListingViewBloc.add(AcceptDeclineRequestEvent(model, true));
          },
          declineRequest: (model) {
            _friendRequestsListingViewBloc.add(AcceptDeclineRequestEvent(model, false));
          },
        );
      case NotificationType.promotionalVideo:
      case NotificationType.promotionalArticle:
        return _promotionalArticleVideo(notification);
      case NotificationType.friendRequestAccepted:
        return _friendRequestAccepted(notification);
      case NotificationType.unknown:
        return const SizedBox.shrink();
      case NotificationType.promotionalContents:
        return const SizedBox.shrink();
    }
  }

  void _onFriendStateChanged(FriendRequestListingViewState state, BuildContext context) {
    if (state is FetchedFriendRequestsListingState) {
      _refreshController
        ..loadComplete()
        ..refreshCompleted();
    } else if (state is FriendRequestListingViewApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is FriendRequestStatusChangedState) {
      _friendRequestsListingViewBloc.add(FetchFriendRequestsEvent(FetchStyle.normal));
      _bloc.add(FetchNotificationsEvent(FetchStyle.normal));
    }
  }
}
