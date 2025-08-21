part of 'social_goal_listing_view_bloc.dart';

@immutable
abstract class SocialGoalListingViewEvent {}

class FetchSocialGoalsEvent extends SocialGoalListingViewEvent {
  FetchSocialGoalsEvent(this.date, this.user);
  final DateTime date;
  final UserDomain user;
}

class DeleteSocialGoalsEvent extends SocialGoalListingViewEvent {
  DeleteSocialGoalsEvent(this.goal);
  final SocialGoalDomain goal;
}

class RemindSocialGoalEvent extends SocialGoalListingViewEvent {
  RemindSocialGoalEvent(this.goal);
  final SocialGoalDomain goal;
}
