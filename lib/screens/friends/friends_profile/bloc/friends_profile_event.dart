part of 'friends_profile_bloc.dart';

@immutable
abstract class FriendsProfileEvent {}

class InitialEvent extends FriendsProfileEvent {
  InitialEvent(this.id);
  final String id;
}

class FetchUserDetailEvent extends FriendsProfileEvent {}

class SendFriendRequestEvent extends FriendsProfileEvent {
  SendFriendRequestEvent(this.user);
  final UserDomain user;
}

class ReportFriendEvent extends FriendsProfileEvent {
  ReportFriendEvent(this.user);
  final UserDomain user;
}

class RequestActionFriendEvent extends FriendsProfileEvent {
  RequestActionFriendEvent(this.user, this.actionName);
  final UserDomain user;
  final String actionName;
}
