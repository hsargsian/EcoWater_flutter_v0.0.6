part of 'profile_edit_bloc.dart';

@immutable
abstract class ProfileEditEvent {}

class FetchUserInformationEvent extends ProfileEditEvent {
  FetchUserInformationEvent();
}

class ProfileEditRequestEvent extends ProfileEditEvent {
  ProfileEditRequestEvent(this.firstName, this.lastName, this.phoneNumber, this.countryName, this.countryCode);

  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String countryName;
  final String countryCode;
}

class ProfilePictureEditEvent extends ProfileEditEvent {
  ProfilePictureEditEvent(
    this.avatar,
  );

  final XFile avatar;
}

class PerformProfileImagePickEvent extends ProfileEditEvent {
  PerformProfileImagePickEvent(this.image);

  final XFile image;
}
