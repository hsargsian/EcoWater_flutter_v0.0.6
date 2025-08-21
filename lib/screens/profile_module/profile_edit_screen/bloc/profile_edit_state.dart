part of 'profile_edit_bloc.dart';

abstract class ProfileEditState {}

class ProfileEditIdleState extends ProfileEditState {}

class ProfileFetchedState extends ProfileEditState {
  ProfileFetchedState(this.userProfile);
  final UserDomain userProfile;
}

class ProfileUpdateCompleteState extends ProfileEditState {
  ProfileUpdateCompleteState(this.message);
  final String message;
}

class UpdatingProfileState extends ProfileEditState {}

class ProfileEditFormValidationErrorState extends ProfileEditState {
  ProfileEditFormValidationErrorState(this.validationModel);
  final ProfileUpdateFormValidationModel validationModel;
}

class ProfileEditFormValidState extends ProfileEditState {}

class ProfileEditApiErrorState extends ProfileEditState {
  ProfileEditApiErrorState(this.errorMessage);
  final String errorMessage;
}

class ProfileEditImagePickedState extends ProfileEditState {
  ProfileEditImagePickedState(this.file);
  final XFile file;
}
