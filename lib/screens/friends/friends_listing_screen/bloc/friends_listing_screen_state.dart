part of 'friends_listing_screen_bloc.dart';

abstract class FriendsListingScreenState {}

class FriendsListingScreenIdleState extends FriendsListingScreenState {}

class FetchingFriendsState extends FriendsListingScreenState {}

class FetchedFriendsState extends FriendsListingScreenState {
  FetchedFriendsState();
}

class FriendsListingScreenMessageState extends FriendsListingScreenState {
  FriendsListingScreenMessageState(this.message, this.style);
  final String message;
  final SnackbarStyle style;
}

class UnfriendingState extends FriendsListingScreenState {
  UnfriendingState();
}
