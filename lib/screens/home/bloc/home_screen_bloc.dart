import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/domain_models/notification_count_domain.dart';
import 'package:echowater/core/domain/domain_models/personal_goal_graph_domain.dart';
import 'package:echowater/core/domain/domain_models/todays_progress_domain.dart';
import 'package:echowater/core/domain/domain_models/usage_streak_domain.dart';
import 'package:echowater/core/domain/entities/notification_entity/notification_count_entity.dart';
import 'package:echowater/core/domain/entities/todays_progress_entity/todays_progress_entity.dart';
import 'package:echowater/core/domain/entities/usage_streak_entity/usage_streak_entity.dart';
import 'package:echowater/core/domain/repositories/flask_repository.dart';
import 'package:echowater/core/domain/repositories/goals_and_stats_repository.dart';
import 'package:echowater/core/domain/repositories/notification_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/domain/domain_models/flask_wrapper_domain.dart';
import '../../../core/domain/domain_models/user_domain.dart';
import '../../../core/domain/repositories/user_repository.dart';
import '../../../core/services/marketing_push_service/marketing_push_service.dart';
import '../../../oc_libraries/ble_service/ble_manager.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc(
      {required GoalsAndStatsRepository goalsAndStatsRepository,
      required FlaskRepository flaskRepository,
      required NotificationRepository notificationRepository,
      required UserRepository userRepository,
      required MarketingPushService marketingPushService})
      : _goalsAndStatsRepository = goalsAndStatsRepository,
        _userRepository = userRepository,
        _notificationRepository = notificationRepository,
        _flaskRepository = flaskRepository,
        _marketingPushService = marketingPushService,
        super(HomeScreenIdleState()) {
    on<FetchTodayProgressEvent>(_onFetchTodayProgress);
    on<FetchNotificationCountEvent>(_onFetchNotificationCountEvent);
    on<FetchUserInformationEvent>(_onFetchUserProfile);
    on<FetchUsageStreakEvent>(_onFetchUsageStreak);
    on<FetchPersonalGoalGraphDataEvent>(_onFetchPersonalGoalGraphData);
    on<FetchMyFlasksEvent>(_onFetchMyDevices);
  }
  final GoalsAndStatsRepository _goalsAndStatsRepository;
  final FlaskRepository _flaskRepository;
  final NotificationRepository _notificationRepository;
  final UserRepository _userRepository;
  final MarketingPushService _marketingPushService;

  TodaysProgressDomain todayProgressDomain =
      TodaysProgressDomain(TodaysProgressEntity(0, 0, 0, 0, 0, 0));

  NotificationCountDomain notificationCount =
      NotificationCountDomain(NotificationCountEntity(0));

  List<PersonalGoalGraphDomain> personalGoalGraphDomains = [];

  UsageStreakDomain usageStreakDomain =
      UsageStreakDomain(UsageStreakEntity(0, 0, 0, 0, 0));

  UserDomain? profileInformation;
  FlaskWrapperDomain flasksWrapper = FlaskWrapperDomain(
    true,
    [],
  );
  Future<void> _onFetchTodayProgress(
    FetchTodayProgressEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    final response = await _goalsAndStatsRepository.fetchTodayProgress();
    response.when(success: (todayProgressResponse) {
      todayProgressDomain = TodaysProgressDomain(todayProgressResponse);
      todayProgressDomain.hasFetched = true;
      Future.delayed(const Duration(seconds: 40), () {
        BleManager().updateGoals(todayProgressDomain);
      });
      emit(FetchedStatsState());
    }, error: (error) {
      emit(HomeScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchNotificationCountEvent(
    FetchNotificationCountEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    final response =
        await _notificationRepository.fetchUnreadNotificationCount();
    response.when(success: (responseObj) {
      notificationCount = NotificationCountDomain(responseObj);
      emit(FetchedStatsState());
    }, error: (error) {
      emit(HomeScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchMyDevices(
    FetchMyFlasksEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    final response =
        await _flaskRepository.fetchMyFlasks(offset: 0, perPage: 100);
    response.when(success: (devicesResponse) {
      flasksWrapper = devicesResponse.toDomain();
      emit(FetchedMyFlasksState());
    }, error: (error) {
      emit(HomeScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchPersonalGoalGraphData(
    FetchPersonalGoalGraphDataEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    final response =
        await _goalsAndStatsRepository.fetchPersonalGoalGraphEntity(
            startDate: event.startDate,
            endDate: event.endDate,
            goalType: event.goalType);
    response.when(success: (responseData) {
      personalGoalGraphDomains =
          responseData.map(PersonalGoalGraphDomain.new).toList();
      emit(FetchedStatsState());
    }, error: (error) {
      emit(HomeScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchUserProfile(
    FetchUserInformationEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    final response = await _userRepository.fetchUserDetails();
    response.when(success: (userEntity) {
      profileInformation = UserDomain(userEntity, true);
      emit(ProfileFetchedState());
    }, error: (error) {
      emit(HomeScreenApiErrorState(
        error.toMessage(),
      ));
    });
  }

  Future<void> _onFetchUsageStreak(
    FetchUsageStreakEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    final response = await _goalsAndStatsRepository.fetchUsageStreak();
    response.when(success: (usageStreakEntity) {
      usageStreakDomain = UsageStreakDomain(usageStreakEntity);
      usageStreakDomain.hasFetched = true;
      _marketingPushService.addProperties(usageStreakEntity.toJson());
      emit(FetchedStatsState());
      Future.delayed(const Duration(seconds: 60), () {
        BleManager().updateStreaks(usageStreakDomain);
      });
    }, error: (error) {
      emit(HomeScreenApiErrorState(
        error.toMessage(),
      ));
    });
  }
}
