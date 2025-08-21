part of 'home_screen_bloc.dart';

abstract class HomeScreenState {}

class HomeScreenIdleState extends HomeScreenState {}

class FetchingStatsState extends HomeScreenState {}

class FetchingProfileState extends HomeScreenState {}

class FetchedStatsState extends HomeScreenState {
  FetchedStatsState();
}

class HomeScreenApiErrorState extends HomeScreenState {
  HomeScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}

class ProfileFetchedState extends HomeScreenState {}

class FetchedMyFlasksState extends HomeScreenState {}
