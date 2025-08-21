import 'package:bloc/bloc.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_manager.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/domain_models/walk_through_progress_domain.dart';
import '../../../../core/domain/repositories/user_repository.dart';
import '../../../../core/injector/injector.dart';
import '../../../auth/authentication/bloc/authentication_bloc.dart';

part 'tooltip_settings_screen_event.dart';
part 'tooltip_settings_screen_state.dart';

class TooltipSettingsScreenBloc
    extends Bloc<TooltipSettingsScreenEvent, TooltipSettingsScreenState> {
  TooltipSettingsScreenBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(TooltipSettingsIdleState()) {
    on<FetchTooltipInformationEvent>(_onFetchTooltipDetail);
    on<TooltipEditRequestEvent>(_onUpdateTooltipState);
  }

  final UserRepository _userRepository;
  bool isTooltipEnabled = true;
  bool isToolTipFetched = false;

  Future<void> _onUpdateTooltipState(TooltipEditRequestEvent event,
      Emitter<TooltipSettingsScreenState> emit) async {
    final currentUser = await _userRepository.getCurrentUserId();
    if (currentUser == null) {
      emit(TooltipApiErrorState('user_session_expired_message'.localized));
      Injector.instance<AuthenticationBloc>().add(
          ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      return;
    }
    final data = {
      'has_seen_homescreen_walkthrough': !event.showTooltip,
      'has_seen_dashboard_walkthrough': !event.showTooltip,
      'has_seen_learning_walkthrough': !event.showTooltip,
      'has_seen_goal_walkthrough': !event.showTooltip,
    };
    final response = await _userRepository.updateWalkthroughProgress(data);
    response.when(success: (walkThroughResponse) {
      final walkThroughProgressDomain =
          WalkThroughProgressDomain(walkThroughResponse);
      isTooltipEnabled = walkThroughProgressDomain.isTooltipEnabled;

      if (!isTooltipEnabled) {
        WalkThroughManager().setAllSeen();
      }
      emit(TooltipInfoUpdatedState(event.showTooltip));
    }, error: (error) {
      emit(TooltipApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchTooltipDetail(FetchTooltipInformationEvent event,
      Emitter<TooltipSettingsScreenState> emit) async {
    final currentUserId = await _userRepository.getCurrentUserId();
    if (currentUserId == null) {
      if (currentUserId == null) {
        emit(TooltipApiErrorState('User session has expired'));
        Injector.instance<AuthenticationBloc>().add(
            ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
        return;
      }
    }
    final response = await _userRepository.fetchWalkthroughProgress();
    response.when(success: (walkThroughResponse) {
      final walkThroughProgressDomain =
          WalkThroughProgressDomain(walkThroughResponse);
      isTooltipEnabled = walkThroughProgressDomain.isTooltipEnabled;
      isToolTipFetched = true;
      emit(TooltipInfoFetchedState());
    }, error: (error) {
      emit(TooltipApiErrorState(error.toMessage()));
    });
  }
}
