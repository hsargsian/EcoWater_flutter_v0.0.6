part of 'personal_goal_listing_view_bloc.dart';

abstract class PersonalGoalListingViewBlocState {}

class PersonalGoalListingViewIdleState
    extends PersonalGoalListingViewBlocState {}

class FetchingPersonalGoalsState extends PersonalGoalListingViewBlocState {}

class FetchedPersonalGoalsState extends PersonalGoalListingViewBlocState {
  FetchedPersonalGoalsState();
}

class DeletedPersonalGoalState extends PersonalGoalListingViewBlocState {
  DeletedPersonalGoalState(this.message);
  final String message;
}

class PersonalGoalListingViewApiErrorState
    extends PersonalGoalListingViewBlocState {
  PersonalGoalListingViewApiErrorState(this.errorMessage);
  final String errorMessage;
}
