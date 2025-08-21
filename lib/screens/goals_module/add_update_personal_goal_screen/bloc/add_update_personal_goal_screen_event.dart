part of 'add_update_personal_goal_screen_bloc.dart';

abstract class AddUpdatePersonalGoalScreenEvent {}

class AddUpdatePersonalGoalEvent extends AddUpdatePersonalGoalScreenEvent {
  AddUpdatePersonalGoalEvent(this.goalRequest);
  final AddGoalRequestModel goalRequest;
}

class SetPersonalGoalEvent extends AddUpdatePersonalGoalScreenEvent {
  SetPersonalGoalEvent(this.goal);
  final PersonalGoalDomain? goal;
}
