import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/domain_models/usage_dates_domain.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/domain_models/week_one_training_stat_domain.dart';
import 'package:echowater/core/domain/domain_models/week_one_traning_domain.dart';
import 'package:echowater/core/domain/entities/usage_dates_entity/usage_dates_entity.dart';
import 'package:echowater/core/domain/repositories/goals_and_stats_repository.dart';
import 'package:echowater/core/domain/repositories/user_repository.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/domain_models/usage_streak_domain.dart';
import '../../../../core/domain/entities/usage_streak_entity/usage_streak_entity.dart';
import '../../../../core/injector/injector.dart';
import '../../../auth/authentication/bloc/authentication_bloc.dart';

part 'goals_screen_event.dart';
part 'goals_screen_state.dart';

class GoalsScreenBloc extends Bloc<GoalsScreenEvent, GoalsScreenState> {
  GoalsScreenBloc(
      {required GoalsAndStatsRepository repository,
      required UserRepository userRepository})
      : _repository = repository,
        _userRepository = userRepository,
        super(GoalsScreenIdleState()) {
    on<FetchUserInformationEvent>(_onFetchUserInformation);
    on<FetchWeekOneTrainingSetEvent>(_onFetchWeekOneTrainingSet);
    on<FetchUsageDatesEvent>(_onFetchUsageDates);
    on<FetchMyWeekOneTrainingStatsEvent>(_onFetchMyWeekOneTrainingStats);
    on<UpdateWeekOneTrainingViewEvent>(_onUpdateWeekOneTrainingViewEvent);
    on<FetchUsageStreakEvent>(_onFetchUsageStreak);
    on<CloseWeekOneTrainingViewEvent>(_onCloseWeekOneTraining);
  }
  final GoalsAndStatsRepository _repository;
  final UserRepository _userRepository;

  UsageStreakDomain usageStreakDomain =
      UsageStreakDomain(UsageStreakEntity(0, 0, 0, 0, 0));

  bool hasFetchedWeekOneTrainingSet = false;
  List<WeekOneTraningDomain> weekOneTrainingDomains = [];
  late WeekOneTraningStatDomain weekOneTrainingStatsDomain;
  late UserDomain user;
  bool hasFetchedUserDetails = false;
  UsageDatesDomain usageDates = UsageDatesDomain(UsageDatesEntity([]));

  Future<void> _onFetchUserInformation(
      FetchUserInformationEvent event, Emitter<GoalsScreenState> emit) async {
    final userEntity = await _userRepository.getCurrentUserFromCache();
    if (userEntity == null) {
      Injector.instance<AuthenticationBloc>().add(
          ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      return;
    }
    user = UserDomain(userEntity, true);
    hasFetchedUserDetails = true;
    emit(FetchedUserInformationState());
  }

  Future<void> _onFetchUsageDates(
      FetchUsageDatesEvent event, Emitter<GoalsScreenState> emit) async {
    final response = await _repository.fetchUsageDates(
        startDate: event.startDate, endDate: event.endDate);
    response.when(success: (response) {
      usageDates = UsageDatesDomain(response);
      emit(FetchedCalendarEventsState());
    }, error: (error) {
      emit(GoalsScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchMyWeekOneTrainingStats(
      FetchMyWeekOneTrainingStatsEvent event,
      Emitter<GoalsScreenState> emit) async {
    if (!hasFetchedUserDetails) {
      final response = await _userRepository.getCurrentUserFromCache();
      if (response == null) {
        return;
      }
      user = UserDomain(response, true);
    }

    final response = await _repository.fetchMyWeekOneTrainingStats();
    response.when(success: (response) {
      weekOneTrainingStatsDomain = WeekOneTraningStatDomain(response);
      weekOneTrainingStatsDomain.updateWithCurrentUser(user);
      emit(FetchedWeekOneTrainingState());
    }, error: (error) {
      emit(GoalsScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchWeekOneTrainingSet(
    FetchWeekOneTrainingSetEvent event,
    Emitter<GoalsScreenState> emit,
  ) async {
    emit(FetchingWeekOneTrainingState());
    final response = await _repository.fetchWeekOneTrainingSet();
    response.when(success: (response) {
      weekOneTrainingDomains = response.map(WeekOneTraningDomain.new).toList();
      hasFetchedWeekOneTrainingSet = true;
      add(FetchMyWeekOneTrainingStatsEvent());
    }, error: (error) {
      emit(GoalsScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onCloseWeekOneTraining(
    CloseWeekOneTrainingViewEvent event,
    Emitter<GoalsScreenState> emit,
  ) async {
    final response = await _repository.closeWeekOneTrainingView();
    response.when(success: (_) {
      hasFetchedWeekOneTrainingSet = false;
      weekOneTrainingStatsDomain.updateWeekTrainingClosed();
      emit(FetchedWeekOneTrainingState());
    }, error: (error) {
      emit(GoalsScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onUpdateWeekOneTrainingViewEvent(
    UpdateWeekOneTrainingViewEvent event,
    Emitter<GoalsScreenState> emit,
  ) async {
    final currentDay =
        weekOneTrainingStatsDomain.getDay(event.currentWeekProgressDay);
    final response = await _repository.updateWeekOneTrainingViewState(
        currentDay: currentDay);
    response.when(success: (_) {
      hasFetchedWeekOneTrainingSet = false;
      emit(FetchedWeekOneTrainingState());
    }, error: (error) {
      emit(GoalsScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchUsageStreak(
    FetchUsageStreakEvent event,
    Emitter<GoalsScreenState> emit,
  ) async {
    final response = await _repository.fetchUsageStreak();
    response.when(success: (usageStreakEntity) {
      usageStreakDomain = UsageStreakDomain(usageStreakEntity);
      usageStreakDomain.hasFetched = true;
      BleManager().updateStreaks(usageStreakDomain);
      emit(FetchedStatsState());
    }, error: (error) {
      emit(GoalsScreenApiErrorState(
        error.toMessage(),
      ));
    });
  }
}
