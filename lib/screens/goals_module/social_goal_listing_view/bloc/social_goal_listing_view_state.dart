part of 'social_goal_listing_view_bloc.dart';

abstract class SocialGoalListingViewBlocState {}

class SocialGoalListingViewIdleState extends SocialGoalListingViewBlocState {}

class FetchingSocialGoalsState extends SocialGoalListingViewBlocState {}

class FetchedSocialGoalsState extends SocialGoalListingViewBlocState {
  FetchedSocialGoalsState();
}

class ReminderSentState extends SocialGoalListingViewBlocState {
  ReminderSentState(this.message);
  final String message;
}

class DeletedSocialGoalState extends SocialGoalListingViewBlocState {
  DeletedSocialGoalState(this.message);
  final String message;
}

class SocialGoalListingViewMessageState extends SocialGoalListingViewBlocState {
  SocialGoalListingViewMessageState(this.message, this.style);
  final String message;
  final SnackbarStyle style;
}
