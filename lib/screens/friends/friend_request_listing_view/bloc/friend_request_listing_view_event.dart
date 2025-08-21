part of 'friend_request_listing_view_bloc.dart';

@immutable
abstract class FriendRequestListingViewEvent {}

class FetchFriendRequestsEvent extends FriendRequestListingViewEvent {
  FetchFriendRequestsEvent(this.fetchStyle);
  final FetchStyle fetchStyle;
}

class SetFriendRequestListingType extends FriendRequestListingViewEvent {
  SetFriendRequestListingType(this.isSubSectionView);
  final bool isSubSectionView;
}

class AcceptDeclineRequestEvent extends FriendRequestListingViewEvent {
  AcceptDeclineRequestEvent(this.request, this.isAccept);
  final FriendRequestDomain request;
  final bool isAccept;
}
