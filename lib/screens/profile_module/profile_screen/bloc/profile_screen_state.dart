part of 'profile_screen_bloc.dart';

abstract class ProfileScreenState {}

class ProfileScreenIdleState extends ProfileScreenState {}

class FetchingProfileState extends ProfileScreenState {}

class LogoutState extends ProfileScreenState {}

class LogedoutState extends ProfileScreenState {
  LogedoutState({required this.message});

  final String message;
}

class ProfileFetchedState extends ProfileScreenState {
  ProfileFetchedState(this.userProfile);
  final UserDomain userProfile;
}

class ProfileScreenApiErrorState extends ProfileScreenState {
  ProfileScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}
