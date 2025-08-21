import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/domain_models/social_goal_domain.dart';

import '../../../../core/domain/domain_models/add_goal_request_model.dart';
import '../../../../core/domain/repositories/goals_and_stats_repository.dart';

part 'add_update_scoail_goal_screen_event.dart';
part 'add_update_scoail_goal_screen_state.dart';

class AddUpdateSocialGoalScreenBloc extends Bloc<AddUpdateSocialGoalScreenEvent,
    AddUpdateSocialGoalScreenState> {
  AddUpdateSocialGoalScreenBloc({required GoalsAndStatsRepository repository})
      : _repository = repository,
        super(AddUpdateSocialGoalScreenIdleState()) {
    on<AddUpdateSocialGoalEvent>(_onAddUpdateGoal);
    on<SetSocialGoalEvent>(_onSetGoal);
  }
  final GoalsAndStatsRepository _repository;
  SocialGoalDomain? goal;
  bool isAdd = true;

  Future<void> _onSetGoal(
    SetSocialGoalEvent event,
    Emitter<AddUpdateSocialGoalScreenState> emit,
  ) async {
    goal = event.goal;
    isAdd = event.goal == null;
    emit(GoalSetForEditState());
  }

  Future<void> _onAddUpdateGoal(
    AddUpdateSocialGoalEvent event,
    Emitter<AddUpdateSocialGoalScreenState> emit,
  ) async {
    emit(AddingUpdatingSocialGoalScreenState());
    final validationResponse = event.goalRequest.validate();
    if (validationResponse != null) {
      emit(AddUpdateSocialGoalScreenApiErrorState(
          validationResponse.formattedErrorMessage));
      return;
    }
    if (isAdd) {
      final response = await _repository.addNewSocialGoal(
          goalType: event.goalRequest.goalType.key,
          goalNumber: event.goalRequest.goalNumber,
          name: event.goalRequest.title,
          participants: [event.goalRequest.participant!.id]);
      response.when(success: (goal) {
        emit(AddedUpdatedSocialGoalScreenState());
      }, error: (error) {
        emit(AddUpdateSocialGoalScreenApiErrorState(error.toMessage()));
      });
    } else {
      final response = await _repository.updateSocialGoal(
          goalId: goal!.id,
          goalType: event.goalRequest.goalType.key,
          goalNumber: event.goalRequest.goalNumber,
          name: event.goalRequest.title,
          participants: [event.goalRequest.participant!.id]);
      response.when(success: (response) {
        emit(AddedUpdatedSocialGoalScreenState());
      }, error: (error) {
        emit(AddUpdateSocialGoalScreenApiErrorState(error.toMessage()));
      });
    }
  }
}
