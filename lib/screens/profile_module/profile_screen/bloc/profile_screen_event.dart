part of 'profile_screen_bloc.dart';

@immutable
abstract class ProfileScreenEvent {}

class FetchUserInformationEvent extends ProfileScreenEvent {
  FetchUserInformationEvent(this.isFetchingPersonalProfile, this.userId);
  String? userId;
  final bool isFetchingPersonalProfile;
}

class LogoutUserRequestEvent extends ProfileScreenEvent {}
