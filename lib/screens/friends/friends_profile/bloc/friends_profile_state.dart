part of 'friends_profile_bloc.dart';

@immutable
sealed class FriendsProfileState {}

final class FriendsProfileInitial extends FriendsProfileState {}

final class FetchUserDataState extends FriendsProfileState {
  FetchUserDataState(this.user);
  final UserDomain user;
}

final class FriendRequestSentState extends FriendsProfileState {}

class FriendsProfileMessageState extends FriendsProfileState {
  FriendsProfileMessageState(this.message, this.style);
  final String message;
  final SnackbarStyle style;
}
