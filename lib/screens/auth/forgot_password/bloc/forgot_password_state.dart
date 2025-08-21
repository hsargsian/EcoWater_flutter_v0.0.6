part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordIdleState extends ForgotPasswordState {}

class ForgotPasswordRequestingState extends ForgotPasswordState {}

class ForgotPasswordRequestedState extends ForgotPasswordState {
  ForgotPasswordRequestedState(this.message);
  final String message;
}

class ForgotPasswordValidationError extends ForgotPasswordState {
  ForgotPasswordValidationError(this.validationModel);
  final ForgotPasswordValidationModel validationModel;
}

class ForgotPasswordValidState extends ForgotPasswordState {}

class ForgotPasswordMessageState extends ForgotPasswordState {
  ForgotPasswordMessageState(this.message, this.style);
  final String message;
  final SnackbarStyle style;
}
