import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_wrapper.dart';
import 'package:echowater/screens/goals_module/goals_screen/bloc/goals_screen_bloc.dart';
import 'package:echowater/screens/goals_module/social_goal_listing_view/social_goal_listing_view.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../base/app_specific_widgets/training_view/week_training_view.dart';
import '../../../base/common_widgets/calendar_widget/calendar_widget.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/images.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/services/refresh.dart';
import '../../../core/services/walkthrough_manager/walk_through_info_view.dart';
import '../../../core/services/walkthrough_manager/walk_through_item.dart';
import '../../../core/services/walkthrough_manager/walk_through_manager.dart';
import '../../../core/services/walkthrough_manager/walk_through_screen_item.dart';
import '../../dashboard/sub_views/tab_contents.dart';
import '../personal_goal_listing_view/personal_goal_listing_view.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late final GoalsScreenBloc _bloc;

  final GlobalKey<CalendarWidgetState> _calendarWidgetStateKey = GlobalKey();
  final GlobalKey<PersonalGoalListingViewState>
      _personalGoalListingViewStateKey = GlobalKey();
  final GlobalKey<SocialGoalListingViewState> _socialGoalListingViewStateKey =
      GlobalKey();
  final ScrollController _scrollController = ScrollController();
  int _currentWeekProgressDay = 0;

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  @override
  void initState() {
    _bloc = Injector.instance<GoalsScreenBloc>();
    super.initState();
    _bloc.add(FetchUserInformationEvent());

    Refresher().refreshGoalScreen = () {
      _fetchInformations(fetchesAll: false);
    };
  }

  void _onCalendarDateSelected(DateTime date) {
    _selectedDate = date;
    _focusedDate = _selectedDate;
    _personalGoalListingViewStateKey.currentState
        ?.setData(_selectedDate, _bloc.user);
    _socialGoalListingViewStateKey.currentState
        ?.setData(_selectedDate, _bloc.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.tertiary,
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Container(
                          height: 15,
                          color: Theme.of(context).colorScheme.tertiary),
                      BlocConsumer<GoalsScreenBloc, GoalsScreenState>(
                        bloc: _bloc,
                        listener: (context, state) {
                          _onStateChanged(state);
                        },
                        builder: (context, state) {
                          return _bloc.hasFetchedUserDetails
                              ? CalendarWidget(
                                  focusedDate: _focusedDate,
                                  key: _calendarWidgetStateKey,
                                  maxFutureDate: DateTime.now().endOfWeek,
                                  maxPastDate: _bloc
                                      .user.accountCreationDate?.startOfWeek,
                                  onWeekMonthChanged: (format, focusedDate) {
                                    _focusedDate = focusedDate;
                                    _bloc.add(FetchUsageDatesEvent(
                                        focusedDate.startOfMonth
                                            .defaultStringDateFormat,
                                        focusedDate.endOfOfMonth
                                            .defaultStringDateFormat));
                                  },
                                  onDateSelected: (calendarFormat, date) {
                                    if (date == _selectedDate) {
                                      return;
                                    }
                                    _onCalendarDateSelected(date);
                                  },
                                  selectedDate: _selectedDate,
                                  events: _bloc.usageDates.dates)
                              : const SizedBox.shrink();
                        },
                      ),
                      BlocBuilder<GoalsScreenBloc, GoalsScreenState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          final hasWalkthrough =
                              WalkThroughManager().currentWalkthroughItem ==
                                  WalkThroughItem.goalsWeekTraining;
                          if (_bloc.hasFetchedWeekOneTrainingSet) {
                            if (_bloc.weekOneTrainingStatsDomain
                                .showsWeekOneTraining()) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: WalkThroughWrapper(
                                  hasWalkThough: hasWalkthrough,
                                  clipRadius: hasWalkthrough ? 10 : 0,
                                  child: WeekTrainingView(
                                    weekOneTrainingStats:
                                        _bloc.weekOneTrainingStatsDomain,
                                    trainingSet: _bloc.weekOneTrainingDomains,
                                    onClosePressed: () {
                                      _bloc.add(UpdateWeekOneTrainingViewEvent(
                                          _currentWeekProgressDay));
                                    },
                                    onCrossPressed: () {
                                      _bloc
                                          .add(CloseWeekOneTrainingViewEvent());
                                    },
                                    onDayChanged: (day) {
                                      _currentWeekProgressDay = day;
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      BlocBuilder<GoalsScreenBloc, GoalsScreenState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          if (_bloc.usageStreakDomain.hasFetched) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: AppBoxedContainer(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Streak'.localized,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondaryElementColor,
                                              fontWeight: FontWeight.w400),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          'Flask Usage',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w400),
                                        )),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              Images.streakFilledIcon,
                                              width: 15,
                                              height: 15,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      AppColors.colorC4A6B5,
                                                      BlendMode.srcIn),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              _bloc.usageStreakDomain
                                                  .currentStreakText(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .colorC4A6B5),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      BlocBuilder<GoalsScreenBloc, GoalsScreenState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          return _bloc.hasFetchedUserDetails
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: PersonalGoalListingView(
                                    isFromGoalScreen: true,
                                    key: _personalGoalListingViewStateKey,
                                    user: _bloc.user,
                                    date: _selectedDate,
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      BlocBuilder<GoalsScreenBloc, GoalsScreenState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          return _bloc.hasFetchedUserDetails
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: SocialGoalListingView(
                                    isFromGoalScreen: true,
                                    user: _bloc.user,
                                    key: _socialGoalListingViewStateKey,
                                    date: _selectedDate,
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      if (WalkThroughManager().currentWalkthroughItem ==
                              WalkThroughItem.goalsPersonalGoals ||
                          WalkThroughManager().currentWalkthroughItem ==
                              WalkThroughItem.goalsTeamGoals)
                        const SizedBox(
                          height: 300,
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Visibility(
              visible: WalkThroughManager().isShowingWalkThrough,
              child: Positioned.fill(
                  child: Container(
                color: AppColors.walkthroughBarrierColor,
              ))),
          Visibility(
            visible: WalkThroughManager().currentWalkthroughItem !=
                WalkThroughItem.none,
            // ignore: prefer_const_constructors
            child: Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                // ignore: prefer_const_constructors
                child: WalkThroughInfoView(
                  screenItem: WalkThroughScreenItem.goals,
                )),
          )
        ],
      ),
    );
  }

  void _scrollToTargetWidget() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
          WalkThroughManager().currentWalkthroughItem.offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
    }
  }

  void _fetchInformations({bool fetchesAll = true}) {
    if (fetchesAll) {
      _bloc
        ..hasFetchedWeekOneTrainingSet = false
        ..add(FetchUsageStreakEvent())
        ..add(FetchMyWeekOneTrainingStatsEvent())
        ..add(FetchUsageDatesEvent(
            _selectedDate.startOfMonth.defaultStringDateFormat,
            _selectedDate.endOfOfMonth.defaultStringDateFormat));
    } else {
      _bloc.add(FetchUsageDatesEvent(
          _selectedDate.startOfMonth.defaultStringDateFormat,
          _selectedDate.endOfOfMonth.defaultStringDateFormat));
    }
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
        WalkThroughManager().switchTabScreen?.call(DashboardTabs.learning);
      }
    };
    Future.delayed(const Duration(seconds: 2), () {
      if (WalkThroughManager().currentTab != DashboardTabs.goal) {
        return;
      }
      WalkThroughManager().setGoalsScreenWalkthrough();
    });
  }

  void _onStateChanged(GoalsScreenState state) {
    if (state is GoalsScreenApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is FetchedWeekOneTrainingState) {
      if (_bloc.hasFetchedWeekOneTrainingSet) {
        _setUpWalkthrough();
        return;
      }
      _bloc.add(FetchWeekOneTrainingSetEvent());
    } else if (state is FetchedCalendarEventsState) {
      _calendarWidgetStateKey.currentState
          ?.setData(_bloc.usageDates.dates, _selectedDate, _focusedDate);
      // _refreshController.refreshCompleted();
      _onCalendarDateSelected(_selectedDate);
    } else if (state is FetchedUserInformationState) {
      _fetchInformations();
    }
  }
}
