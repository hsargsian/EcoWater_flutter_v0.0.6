part of 'add_update_personal_goal_screen_bloc.dart';

abstract class AddUpdatePersonalGoalScreenState {}

class AddUpdatePersonalGoalScreenIdleState
    extends AddUpdatePersonalGoalScreenState {}

class AddingUpdatingPersonalGoalScreenState
    extends AddUpdatePersonalGoalScreenState {}

class AddedUpdatedPersonalGoalScreenState
    extends AddUpdatePersonalGoalScreenState {
  AddedUpdatedPersonalGoalScreenState();
}

class GoalSetForEditState extends AddUpdatePersonalGoalScreenState {}

class AddUpdatePersonalGoalScreenApiErrorState
    extends AddUpdatePersonalGoalScreenState {
  AddUpdatePersonalGoalScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}
