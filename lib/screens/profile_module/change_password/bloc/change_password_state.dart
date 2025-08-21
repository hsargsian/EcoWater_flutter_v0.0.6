part of 'change_password_bloc.dart';

abstract class ChangePasswordState {}

class ChangePasswordIdleState extends ChangePasswordState {}

class ChangePasswordRequestingState extends ChangePasswordState {}

class ChangePasswordRequestedState extends ChangePasswordState {
  ChangePasswordRequestedState(this.message);
  final String message;
}

class ChangePasswordValidationError extends ChangePasswordState {
  ChangePasswordValidationError(this.validationModel);
  final ChangePasswordFormValidationModel validationModel;
}

class ChangePasswordValidState extends ChangePasswordState {}

class ChangePassswordApiErrorState extends ChangePasswordState {
  ChangePassswordApiErrorState(this.errorMessage);
  final String errorMessage;
}
