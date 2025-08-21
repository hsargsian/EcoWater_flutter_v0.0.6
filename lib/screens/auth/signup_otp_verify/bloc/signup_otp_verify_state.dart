part of 'signup_otp_verify_bloc.dart';

abstract class SignUpOtpVerifyState {}

class SignUpOtpVerifyIdleState extends SignUpOtpVerifyState {}

class SignedUpOtpVerifedState extends SignUpOtpVerifyState {
  SignedUpOtpVerifedState(this.message);
  final String message;
}

class OtpCodeResentState extends SignUpOtpVerifyState {
  OtpCodeResentState(this.message);
  final String message;
}

class SigningUpOtpVerifingState extends SignUpOtpVerifyState {}

class SignUpOtpVerifyFormValidationErrorState extends SignUpOtpVerifyState {
  SignUpOtpVerifyFormValidationErrorState(this.validationModel);
  final SignUpOtpVerifyFormValidationModel validationModel;
}

class SignUpOtpVerifyFormValidState extends SignUpOtpVerifyState {}

class SignUpOtpVerifyMessageState extends SignUpOtpVerifyState {
  SignUpOtpVerifyMessageState(this.message, this.style);
  final String message;
  final SnackbarStyle style;
}
