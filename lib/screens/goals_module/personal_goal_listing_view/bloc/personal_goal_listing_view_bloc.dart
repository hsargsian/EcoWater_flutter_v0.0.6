import 'package:bloc/bloc.dart';
import 'package:echowater/base/app_specific_widgets/bottle_and_ppm_view/bottles_and_ppm_selector.dart';
import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/personal_goal_domain.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/entities/personal_goal_entity/personal_goal_entity.dart';
import 'package:echowater/core/domain/repositories/goals_and_stats_repository.dart';
import 'package:echowater/core/domain/repositories/user_repository.dart';
import 'package:echowater/screens/home/bloc/home_screen_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/domain_models/todays_progress_domain.dart';
import '../../../../core/injector/injector.dart';
import '../../../../oc_libraries/ble_service/ble_manager.dart';
import '../../../auth/authentication/bloc/authentication_bloc.dart';

part 'personal_goal_listing_view_event.dart';
part 'personal_goal_listing_view_state.dart';

class PersonalGoalListingViewBloc extends Bloc<PersonalGoalListingViewEvent,
    PersonalGoalListingViewBlocState> {
  PersonalGoalListingViewBloc({
    required GoalsAndStatsRepository goalsAndStatsRepository,
    required UserRepository userRepository,
  })  : _goalsAndStatsRepository = goalsAndStatsRepository,
        _userRepository = userRepository,
        super(PersonalGoalListingViewIdleState()) {
    on<FetchPersonalGoalsEvent>(_onFetchPersonalGoals);
    on<DeletePersonalGoalsEvent>(_onDeletePersonalGoal);
    on<FetchTodayProgressEvent>(_onFetchTodayProgress);
  }
  final GoalsAndStatsRepository _goalsAndStatsRepository;
  final UserRepository _userRepository;
  bool isMyGoalList = false;

  List<PersonalGoalDomain> personalGoals = [];
  List<PersonalGoalDomain> dummyPersonalGoals = PersonalGoalDomain.dummyGoals();

  Future<void> _onFetchPersonalGoals(
    FetchPersonalGoalsEvent event,
    Emitter<PersonalGoalListingViewBlocState> emit,
  ) async {
    emit(FetchingPersonalGoalsState());
    final userEntity = await _userRepository.getCurrentUserFromCache();
    if (userEntity == null) {
      emit(PersonalGoalListingViewApiErrorState(
          'user_session_expired_message'.localized));
      Injector.instance<AuthenticationBloc>().add(
          ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      return;
    }
    isMyGoalList = userEntity.id == event.user.id;
    final response = await _goalsAndStatsRepository.fetchPersonalGoals(
        date: event.date.defaultStringDateFormat, userId: event.user.id);
    response.when(success: (goals) {
      personalGoals =
          goals.map((e) => PersonalGoalDomain(e, event.date, '')).toList();
      _configureGoalList(event.date);
      personalGoals.sort((a, b) {
        return a.bottlePPmType.order - b.bottlePPmType.order;
      });
      add(FetchTodayProgressEvent());
      emit(FetchedPersonalGoalsState());
    }, error: (error) {
      emit(PersonalGoalListingViewApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchTodayProgress(
    FetchTodayProgressEvent event,
    Emitter<PersonalGoalListingViewBlocState> emit,
  ) async {
    final response = await _goalsAndStatsRepository.fetchTodayProgress();
    response.when(
        success: (todayProgressResponse) {
          final todayProgressDomain =
              TodaysProgressDomain(todayProgressResponse);
          BleManager().updateGoals(todayProgressDomain);
        },
        error: (error) {});
  }

  void _configureGoalList(DateTime date) {
    if (!isMyGoalList) {
      return;
    }
    if (date.isDateInPast) {
      return;
    }

    if (personalGoals.length == 3) {
      return;
    }

    if (personalGoals.isEmpty) {
      personalGoals
        ..add(PersonalGoalDomain(
            PersonalGoalEntity('-1', BottleOrPPMType.bottle.key, 0, 0, true),
            DateTime.now(),
            'Flask Goal'))
        ..add(PersonalGoalDomain(
            PersonalGoalEntity('-2', BottleOrPPMType.ppms.key, 0, 0, true),
            DateTime.now(),
            'H2 Goal'))
        ..add(PersonalGoalDomain(
            PersonalGoalEntity('-3', BottleOrPPMType.water.key, 0, 0, true),
            DateTime.now(),
            'Water Goal'));
      return;
    }
    if (personalGoals.length == 1) {
      final type = personalGoals.first.bottlePPmType;
      if (type == BottleOrPPMType.bottle) {
        personalGoals
          ..add(PersonalGoalDomain(
              PersonalGoalEntity('-2', BottleOrPPMType.ppms.key, 0, 0, true),
              DateTime.now(),
              'H2 Goal'))
          ..add(PersonalGoalDomain(
              PersonalGoalEntity('-3', BottleOrPPMType.water.key, 0, 0, true),
              DateTime.now(),
              'Water Goal'));
      } else if (type == BottleOrPPMType.ppms) {
        personalGoals
          ..insert(
              0,
              PersonalGoalDomain(
                  PersonalGoalEntity(
                      '-1', BottleOrPPMType.bottle.key, 0, 0, true),
                  DateTime.now(),
                  'Flask Goal'))
          ..add(PersonalGoalDomain(
              PersonalGoalEntity('-3', BottleOrPPMType.water.key, 0, 0, true),
              DateTime.now(),
              'Water Goal'));
      } else if (type == BottleOrPPMType.water) {
        personalGoals
          ..insert(
              0,
              PersonalGoalDomain(
                  PersonalGoalEntity(
                      '-1', BottleOrPPMType.bottle.key, 0, 0, true),
                  DateTime.now(),
                  'Flask Goal'))
          ..insert(
              1,
              PersonalGoalDomain(
                  PersonalGoalEntity(
                      '-2', BottleOrPPMType.ppms.key, 0, 0, true),
                  DateTime.now(),
                  'H2 Goal'));
      }
      return;
    }
    if (personalGoals.length == 2) {
      final type1 = personalGoals.first.bottlePPmType;
      final type2 = personalGoals.last.bottlePPmType;
      if (type1 == BottleOrPPMType.bottle && type2 == BottleOrPPMType.ppms) {
        personalGoals.add(PersonalGoalDomain(
            PersonalGoalEntity('-3', BottleOrPPMType.water.key, 0, 0, true),
            DateTime.now(),
            'Water Goal'));
      } else if (type1 == BottleOrPPMType.bottle &&
          type2 == BottleOrPPMType.water) {
        personalGoals.add(PersonalGoalDomain(
            PersonalGoalEntity('-2', BottleOrPPMType.ppms.key, 0, 0, true),
            DateTime.now(),
            'H2 Goal'));
      } else if (type1 == BottleOrPPMType.ppms &&
          type2 == BottleOrPPMType.water) {
        personalGoals.add(PersonalGoalDomain(
            PersonalGoalEntity('-1', BottleOrPPMType.bottle.key, 0, 0, true),
            DateTime.now(),
            'Flask Goal'));
      }
      return;
    }
  }

  Future<void> _onDeletePersonalGoal(
    DeletePersonalGoalsEvent event,
    Emitter<PersonalGoalListingViewBlocState> emit,
  ) async {
    final response = await _goalsAndStatsRepository.deletePersonalGoal(
        goalId: event.goal.id);
    response.when(success: (responseBody) {
      personalGoals.remove(event.goal);
      emit(DeletedPersonalGoalState(responseBody.message));
    }, error: (error) {
      emit(PersonalGoalListingViewApiErrorState(error.toMessage()));
    });
  }
}
