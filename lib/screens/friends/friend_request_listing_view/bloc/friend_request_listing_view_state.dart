part of 'friend_request_listing_view_bloc.dart';

abstract class FriendRequestListingViewState {}

class FriendRequestsListingViewIdleState
    extends FriendRequestListingViewState {}

class FetchingFriendRequestsListingState
    extends FriendRequestListingViewState {}

class FetchedFriendRequestsListingState extends FriendRequestListingViewState {
  FetchedFriendRequestsListingState();
}

class FriendRequestListingViewApiErrorState
    extends FriendRequestListingViewState {
  FriendRequestListingViewApiErrorState(this.errorMessage);
  final String errorMessage;
}

class FriendRequestStatusChangedState extends FriendRequestListingViewState {
  FriendRequestStatusChangedState();
}
