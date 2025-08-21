part of 'add_update_scoail_goal_screen_bloc.dart';

abstract class AddUpdateSocialGoalScreenState {}

class AddUpdateSocialGoalScreenIdleState
    extends AddUpdateSocialGoalScreenState {}

class AddingUpdatingSocialGoalScreenState
    extends AddUpdateSocialGoalScreenState {}

class AddedUpdatedSocialGoalScreenState extends AddUpdateSocialGoalScreenState {
  AddedUpdatedSocialGoalScreenState();
}

class GoalSetForEditState extends AddUpdateSocialGoalScreenState {}

class AddUpdateSocialGoalScreenApiErrorState
    extends AddUpdateSocialGoalScreenState {
  AddUpdateSocialGoalScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}
