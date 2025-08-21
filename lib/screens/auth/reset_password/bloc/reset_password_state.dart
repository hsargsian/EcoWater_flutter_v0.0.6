part of 'reset_password_bloc.dart';

abstract class ResetPasswordState {}

class ResetPasswordIdleState extends ResetPasswordState {}

class PasswordResetSuccessfulState extends ResetPasswordState {
  PasswordResetSuccessfulState(this.message);
  final String message;
}

class OtpCodeResentState extends ResetPasswordState {
  OtpCodeResentState(this.message);
  final String message;
}

class ResetingPasswordState extends ResetPasswordState {}

class ResetPasswordFormValidationErrorState extends ResetPasswordState {
  ResetPasswordFormValidationErrorState(this.validationModel);
  final ResetPasswordFormValidationModel validationModel;
}

class ResetPasswordFormValidState extends ResetPasswordState {}

class ResetPasswordMessageState extends ResetPasswordState {
  ResetPasswordMessageState(this.message, this.style);
  final String message;
  final SnackbarStyle style;
}
