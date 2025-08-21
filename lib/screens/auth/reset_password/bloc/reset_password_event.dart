part of 'reset_password_bloc.dart';

@immutable
abstract class ResetPasswordEvent {}

class ResetPasswordRequestEvent extends ResetPasswordEvent {
  ResetPasswordRequestEvent(
      this.email, this.newPassword, this.confirmPassword, this.otpCode);
  final String email;
  final String newPassword;
  final String confirmPassword;
  final String otpCode;
}

class ResendOtpCodeRequestEvent extends ResetPasswordEvent {
  ResendOtpCodeRequestEvent(this.email);
  final String email;
}
