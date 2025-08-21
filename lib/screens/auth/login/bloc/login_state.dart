part of 'login_bloc.dart';

abstract class LoginState {}

class LogInIdleState extends LoginState {}

class LoggedInState extends LoginState {}

class LoggingInState extends LoginState {}

class LogInFormValidationErrorState extends LoginState {
  LogInFormValidationErrorState(this.validationModel);
  final LoginRequestModel validationModel;
}

class LogInFormValidState extends LoginState {}

class LoginApiErrorState extends LoginState {
  LoginApiErrorState(this.errorMessage);
  final String errorMessage;
}

class ProfileFetchedState extends LoginState {
  ProfileFetchedState(this.userProfile);
  final UserDomain userProfile;
}

class UnverifiedUserState extends LoginState {}
