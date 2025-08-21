import 'package:bloc/bloc.dart';
import 'package:echowater/base/common_widgets/snackbar/snackbar_style.dart';
import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/social_goal_domain.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_entity.dart';
import 'package:echowater/core/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/repositories/goals_and_stats_repository.dart';

part 'social_goal_listing_view_event.dart';
part 'social_goal_listing_view_state.dart';

class SocialGoalListingViewBloc
    extends Bloc<SocialGoalListingViewEvent, SocialGoalListingViewBlocState> {
  SocialGoalListingViewBloc(
      {required GoalsAndStatsRepository goalsAndStatsRepository,
      required UserRepository userRepository})
      : _goalsAndStatsRepository = goalsAndStatsRepository,
        _userRepository = userRepository,
        super(SocialGoalListingViewIdleState()) {
    on<FetchSocialGoalsEvent>(_onFetchSocialGoals);
    on<DeleteSocialGoalsEvent>(_onDeleteSocialGoal);
    on<RemindSocialGoalEvent>(_onRemindSocialGoal);
  }
  final GoalsAndStatsRepository _goalsAndStatsRepository;
  final UserRepository _userRepository;

  List<SocialGoalDomain> socialGoals = [];
  List<SocialGoalDomain> dummySocialGoals = SocialGoalDomain.dummyGoals();
  bool isMyGoalList = false;
  Future<void> _onFetchSocialGoals(
    FetchSocialGoalsEvent event,
    Emitter<SocialGoalListingViewBlocState> emit,
  ) async {
    emit(FetchingSocialGoalsState());
    final userEntity = await _userRepository.getCurrentUserFromCache();
    if (userEntity == null) {
      emit(SocialGoalListingViewMessageState(
          'user_session_expired_message'.localized, SnackbarStyle.error));
      return;
    }
    final me = UserDomain(userEntity, true);
    isMyGoalList = me == event.user;
    final response = await _goalsAndStatsRepository.fetchSocialGoals(
        date: event.date.defaultStringDateFormat, userId: event.user.id);
    response.when(success: (goals) {
      socialGoals =
          goals.map((item) => SocialGoalDomain(item, event.date, me)).toList();
      _configureGoalList(me, event.date);
      emit(FetchedSocialGoalsState());
    }, error: (error) {
      emit(SocialGoalListingViewMessageState(
          error.toMessage(), SnackbarStyle.error));
    });
  }

  void _configureGoalList(UserDomain me, DateTime date) {
    if (!isMyGoalList) {
      return;
    }
    if (date.isDateInPast) {
      return;
    }
    if (socialGoals.isEmpty) {
      socialGoals.add(
          SocialGoalDomain(SocialGoalEntity.dummy(me), DateTime.now(), me));
      return;
    }
  }

  Future<void> _onDeleteSocialGoal(
    DeleteSocialGoalsEvent event,
    Emitter<SocialGoalListingViewBlocState> emit,
  ) async {
    final response =
        await _goalsAndStatsRepository.deleteSocialGoal(goalId: event.goal.id);
    response.when(success: (responseBody) {
      socialGoals.remove(event.goal);
      emit(DeletedSocialGoalState(responseBody.message));
    }, error: (error) {
      emit(SocialGoalListingViewMessageState(
          error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _onRemindSocialGoal(
    RemindSocialGoalEvent event,
    Emitter<SocialGoalListingViewBlocState> emit,
  ) async {
    final otherParticipantId = event.goal.otherParticipant()?.participantId;
    if (otherParticipantId == null) {
      emit(SocialGoalListingViewMessageState(
          'something_wrong'.localized, SnackbarStyle.error));
      return;
    }
    final response = await _goalsAndStatsRepository.remindSocialGoal(
        goalId: event.goal.id, friendId: otherParticipantId);
    response.when(success: (responseBody) {
      emit(ReminderSentState(responseBody.message));
    }, error: (error) {
      emit(SocialGoalListingViewMessageState(
          error.toMessage(), SnackbarStyle.error));
    });
  }
}
