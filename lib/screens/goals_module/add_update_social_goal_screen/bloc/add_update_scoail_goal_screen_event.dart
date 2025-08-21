part of 'add_update_scoail_goal_screen_bloc.dart';

abstract class AddUpdateSocialGoalScreenEvent {}

class AddUpdateSocialGoalEvent extends AddUpdateSocialGoalScreenEvent {
  AddUpdateSocialGoalEvent(this.goalRequest);
  final AddGoalRequestModel goalRequest;
}

class SetSocialGoalEvent extends AddUpdateSocialGoalScreenEvent {
  SetSocialGoalEvent(this.goal);
  final SocialGoalDomain? goal;
}
