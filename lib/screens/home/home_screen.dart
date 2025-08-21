import 'package:echowater/base/app_specific_widgets/dashboard_profile_header_view.dart';
import 'package:echowater/base/app_specific_widgets/graph_view/graph_view_wrapper_view.dart';
import 'package:echowater/base/app_specific_widgets/streaks_and_cycle_stats/streaks_and_cycle_stats_view.dart';
import 'package:echowater/base/app_specific_widgets/today_progress_view/today_progress_view.dart';
import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/core/domain/domain_models/personal_goal_graph_domain.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/core/services/refresh.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_info_view.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_item.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_manager.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_screen_item.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_wrapper.dart';
import 'package:echowater/flavor_config.dart';
import 'package:echowater/screens/dashboard/sub_views/tab_contents.dart';
import 'package:echowater/screens/home/bloc/home_screen_bloc.dart';
import 'package:echowater/screens/profile_module/achievements_screen/achievements_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../base/app_specific_widgets/bottle_and_ppm_view/bottles_and_ppm_selector.dart';
import '../../base/app_specific_widgets/data_syncing_info_view.dart';
import '../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../base/utils/colors.dart';
import '../../base/utils/images.dart';
import '../../base/utils/utilities.dart';
import '../data_tracking_log_screen/data_tracking_log_screen.dart';
import '../notifications_screen/notifications_screen.dart';
import '../protocols/sub_views/protocols_listing_view/protocols_listing_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeScreenBloc _bloc;

  DateTime _focusedDate = DateTime.now();
  CalendarFormat _selectedCalendarFormat = CalendarFormat.week;
  BottleOrPPMType _goalType = BottleOrPPMType.bottle;
  final GlobalKey<GraphViewWrapperViewState> _graphViewWrapperViewState =
      GlobalKey();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _bloc = Injector.instance<HomeScreenBloc>();
    super.initState();
    _fetchInformations();
    Refresher().refreshHomeScreen = () {
      _fetchInformations(fetchFlasks: false);
    };
  }

  void _setUpWalkthrough() {
    WalkThroughManager().reloadScreen = () {
      if (mounted) {
        setState(() {});
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToTargetWidget();
      });
      if (WalkThroughManager().currentWalkthroughItem == WalkThroughItem.none) {
        _fetchInformations();
        WalkThroughManager().switchTabScreen?.call(DashboardTabs.goal);
      }
    };
    Future.delayed(const Duration(seconds: 2), () {
      if (WalkThroughManager().currentTab != DashboardTabs.home) {
        return;
      }
      WalkThroughManager().setHomeScreenWalkthrough();
    });
  }

  void _fetchInformations({bool fetchFlasks = true}) {
    _bloc
      ..add(FetchUserInformationEvent())
      ..add(FetchUsageStreakEvent())
      ..add(FetchTodayProgressEvent())
      ..add(FetchNotificationCountEvent());

    if (fetchFlasks) {
      _bloc.add(FetchMyFlasksEvent());
    }
    _fetchGraphData();
  }

  void _fetchGraphData() {
    if (_selectedCalendarFormat == CalendarFormat.month) {
      _bloc.add(FetchPersonalGoalGraphDataEvent(
          _focusedDate.startOfMonth.defaultStringDateFormat,
          _focusedDate.endOfOfMonth.defaultStringDateFormat,
          _goalType.key));
    } else {
      _bloc.add(FetchPersonalGoalGraphDataEvent(
          _focusedDate.startOfWeek.defaultStringDateFormat,
          _focusedDate.endOfWeek.defaultStringDateFormat,
          _goalType.key));
    }
  }

  void _scrollToTargetWidget() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
          WalkThroughManager().currentWalkthroughItem.offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _navBar(),
        body: BlocConsumer<HomeScreenBloc, HomeScreenState>(
            bloc: _bloc,
            builder: (context, state) {
              return Stack(
                children: [
                  SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          DashboardProfileHeaderView(
                            _bloc.profileInformation,
                            flasks: _bloc.flasksWrapper.flasks,
                          ),
                          ProtocolsListingView(
                            isSubSectionView: true,
                            title: 'Protocols',
                            axis: Axis.horizontal,
                            createProtocolNotifier: ValueNotifier(false),
                          ),
                          TodayProgressView(
                            todayProgress: _bloc.todayProgressDomain,
                            onAdditionSuccess: () {
                              _fetchInformations(fetchFlasks: false);
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GraphViewWrapperView(
                            key: _graphViewWrapperViewState,
                            goalData: WalkThroughManager()
                                    .hasSeenHomeScreenWalkthrough
                                ? _bloc.personalGoalGraphDomains
                                : PersonalGoalGraphDomain.getDummyData(),
                            focusedDate: _focusedDate,
                            maxFutureDate: DateTime.now().endOfWeek,
                            maxPastDate: _bloc.profileInformation
                                ?.accountCreationDate?.startOfWeek,
                            onWeekMonthChanged:
                                (format, focusedDate, goalType) {
                              _focusedDate = focusedDate;
                              _goalType = goalType;
                              _selectedCalendarFormat = format;
                              _fetchGraphData();
                            },
                          ),
                          WalkThroughWrapper(
                            hasWalkThough:
                                WalkThroughManager().currentWalkthroughItem ==
                                    WalkThroughItem.homeProgress,
                            clipRadius: 10,
                            child: StreaksAndCycleStatsView(
                              usageStreak: _bloc.usageStreakDomain,
                            ),
                          ),
                          SizedBox(
                            height:
                                WalkThroughManager().currentWalkthroughItem ==
                                        WalkThroughItem.homeProgress
                                    ? 200
                                    : 20,
                          )
                        ],
                      )),
                  const Positioned(
                      top: 0, left: 0, right: 0, child: DataSyncingInfoView()),
                  Visibility(
                      visible: WalkThroughManager().isShowingWalkThrough,
                      child: Positioned.fill(
                          child: Container(
                        color: AppColors.walkthroughBarrierColor,
                      ))),
                  Visibility(
                    visible: WalkThroughManager().currentWalkthroughItem !=
                        WalkThroughItem.none,
                    child: Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: WalkThroughInfoView(
                          screenItem: WalkThroughScreenItem.home,
                          profile: _bloc.profileInformation,
                        )),
                  ),
                ],
              );
            },
            listener: (context, state) {
              _onStateChanged(state, context);
            }));
  }

  PreferredSizeWidget? _navBar() {
    return EchoWaterNavBar(
        isBaseScreen: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                Images.navBarLogo,
                height: 30,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: FlavorConfig.isNotProduction(),
                      child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context, DataTrackingLogScreen.route());
                            },
                            child: Icon(
                              Icons.info,
                              size: 30,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(2),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, AchievementsScreen.route());
                          },
                          child: SvgPicture.asset(
                            Images.tropy,
                            width: 30,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primary,
                                BlendMode.srcIn),
                          ),
                        )),
                    const SizedBox(
                      width: 4,
                    ),
                    WalkThroughWrapper(
                      hasWalkThough:
                          WalkThroughManager().currentWalkthroughItem ==
                              WalkThroughItem.homeNotification,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, NotificationsScreen.route(
                              onRefetchNotificationCount: () {
                                _bloc.add(FetchNotificationCountEvent());
                              },
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset(
                                    Images.notificationIcon,
                                    width: 18,
                                    colorFilter: ColorFilter.mode(
                                        Theme.of(context).colorScheme.primary,
                                        BlendMode.srcIn),
                                  ),
                                ),
                                BlocBuilder<HomeScreenBloc, HomeScreenState>(
                                  bloc: _bloc,
                                  builder: (context, state) {
                                    return Visibility(
                                      visible: _bloc.notificationCount
                                          .hasUnreadNotifications,
                                      child: Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _onStateChanged(HomeScreenState state, BuildContext context) {
    if (state is HomeScreenApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is FetchedStatsState) {
      WalkThroughManager().initManager(
        onSuccess: () {
          _setUpWalkthrough();
        },
      );
      _graphViewWrapperViewState.currentState?.setData(
          WalkThroughManager().hasSeenHomeScreenWalkthrough
              ? _bloc.personalGoalGraphDomains
              : PersonalGoalGraphDomain.getDummyData(),
          _focusedDate);
    }
  }
}
