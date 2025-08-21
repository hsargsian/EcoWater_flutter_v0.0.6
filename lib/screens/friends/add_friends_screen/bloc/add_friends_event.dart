part of 'add_friends_bloc.dart';

@immutable
sealed class AddFriendsEvent {}

class SearchUsersEvent extends AddFriendsEvent {
  SearchUsersEvent(this.searchString, this.fetchStyle);
  final String searchString;
  final FetchStyle fetchStyle;
}

class UnfriendEvent extends AddFriendsEvent {
  UnfriendEvent(this.user);
  final UserDomain user;
}
