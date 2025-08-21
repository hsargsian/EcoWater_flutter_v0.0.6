part of 'signup_otp_verify_bloc.dart';

@immutable
abstract class SignUpOtpVerifyEvent {}

class SignUpOtpVerifyRequestEvent extends SignUpOtpVerifyEvent {
  SignUpOtpVerifyRequestEvent(this.email, this.otpCode);
  final String email;
  final String otpCode;
}

class ResendOtpCodeRequestEvent extends SignUpOtpVerifyEvent {
  ResendOtpCodeRequestEvent(this.email);
  final String email;
}

class LogInRequestEvent extends SignUpOtpVerifyEvent {
  LogInRequestEvent({required this.email, required this.password});
  final String email;
  final String password;
}

class FetchUserInformationEvent extends SignUpOtpVerifyEvent {
  FetchUserInformationEvent();
}
