import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/domain_models/personal_goal_domain.dart';
import 'package:echowater/core/domain/repositories/goals_and_stats_repository.dart';

import '../../../../core/domain/domain_models/add_goal_request_model.dart';

part 'add_update_personal_goal_screen_event.dart';
part 'add_update_personal_goal_screen_state.dart';

class AddUpdatePersonalGoalScreenBloc extends Bloc<
    AddUpdatePersonalGoalScreenEvent, AddUpdatePersonalGoalScreenState> {
  AddUpdatePersonalGoalScreenBloc({required GoalsAndStatsRepository repository})
      : _repository = repository,
        super(AddUpdatePersonalGoalScreenIdleState()) {
    on<AddUpdatePersonalGoalEvent>(_onAddUpdateGoal);
    on<SetPersonalGoalEvent>(_onSetGoal);
  }
  final GoalsAndStatsRepository _repository;
  PersonalGoalDomain? goal;
  bool isAdd = true;

  Future<void> _onSetGoal(
    SetPersonalGoalEvent event,
    Emitter<AddUpdatePersonalGoalScreenState> emit,
  ) async {
    goal = event.goal;
    isAdd = event.goal == null;
    emit(GoalSetForEditState());
  }

  Future<void> _onAddUpdateGoal(
    AddUpdatePersonalGoalEvent event,
    Emitter<AddUpdatePersonalGoalScreenState> emit,
  ) async {
    emit(AddingUpdatingPersonalGoalScreenState());

    if (isAdd) {
      final response = await _repository.addNewPersonalGoal(
          goalType: event.goalRequest.goalType.key,
          goalNumber: event.goalRequest.goalNumber);
      response.when(success: (goal) {
        emit(AddedUpdatedPersonalGoalScreenState());
      }, error: (error) {
        emit(AddUpdatePersonalGoalScreenApiErrorState(error.toMessage()));
      });
    } else {
      final response = await _repository.updatePersonalGoal(
          goalId: goal!.id,
          goalType: event.goalRequest.goalType.key,
          goalNumber: event.goalRequest.goalNumber);

      response.when(success: (response) {
        emit(AddedUpdatedPersonalGoalScreenState());
      }, error: (error) {
        emit(AddUpdatePersonalGoalScreenApiErrorState(error.toMessage()));
      });
    }
  }
}
