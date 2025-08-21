part of 'signup_bloc.dart';

abstract class SignUpState {}

class SignUpIdleState extends SignUpState {}

class SignedUpState extends SignUpState {
  SignedUpState(this.message);
  final String message;
}

class SigningUpState extends SignUpState {}

class SignUpFormValidationErrorState extends SignUpState {
  SignUpFormValidationErrorState(this.validationModel);
  final SignUpFormValidationModel validationModel;
}

class SignUpFormValidState extends SignUpState {}

class SignUpMessageState extends SignUpState {
  SignUpMessageState(this.message, this.style);
  final String message;
  final SnackbarStyle style;
}

class LoggedInState extends SignUpState {}

class ProfileFetchedState extends SignUpState {
  ProfileFetchedState(this.userProfile);
  final UserDomain userProfile;
}

class FetchedSystemAccessState extends SignUpState {
  FetchedSystemAccessState(this.systemAccessInfo);
  final SystemAccessStateDomain systemAccessInfo;
}
