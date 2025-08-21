part of 'personal_goal_listing_view_bloc.dart';

@immutable
abstract class PersonalGoalListingViewEvent {}

class FetchPersonalGoalsEvent extends PersonalGoalListingViewEvent {
  FetchPersonalGoalsEvent(this.date, this.user);
  final DateTime date;
  final UserDomain user;
}

class DeletePersonalGoalsEvent extends PersonalGoalListingViewEvent {
  DeletePersonalGoalsEvent(this.goal);
  final PersonalGoalDomain goal;
}

class FetchTodayProgressEvent extends PersonalGoalListingViewEvent {
  FetchTodayProgressEvent();
}
