part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationStatusChangeEvent extends AuthenticationEvent {
  AuthenticationStatusChangeEvent(this.status);
  final bool status;
}

class AuthenticationCheckUserSessionEvent extends AuthenticationEvent {
  AuthenticationCheckUserSessionEvent();
}

class FetchUserInfoEvent extends AuthenticationEvent {
  FetchUserInfoEvent();
}

class ExpireUserSessionEvent extends AuthenticationEvent {
  ExpireUserSessionEvent(
      {required this.resetsDevice, required this.deleteAccount});
  final bool resetsDevice;
  final bool deleteAccount;
}
