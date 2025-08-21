part of 'add_friends_bloc.dart';

abstract class AddFriendsState {}

class AddFriendsIdleState extends AddFriendsState {}

class FetchingSearchResultState extends AddFriendsState {}

class FetchedSearchResultState extends AddFriendsState {
  FetchedSearchResultState();
}

class AddFriendMessageState extends AddFriendsState {
  AddFriendMessageState(this.messagae, this.style);
  final String messagae;
  final SnackbarStyle style;
}
