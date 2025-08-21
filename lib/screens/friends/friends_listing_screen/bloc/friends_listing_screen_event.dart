part of 'friends_listing_screen_bloc.dart';

@immutable
abstract class FriendsListingScreenEvent {}

class FetchFriendListEvent extends FriendsListingScreenEvent {
  FetchFriendListEvent(this.fetchStyle, this.searchString);
  final FetchStyle fetchStyle;
  final String searchString;
}

class UnfriendEvent extends FriendsListingScreenEvent {
  UnfriendEvent(this.friend);
  final FriendDomain friend;
}
