import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../../core/domain/repositories/auth_repository.dart';
import '../model/signup_opt_verify_form_validation_model.dart';
import '../model/signup_otp_resend_validation_model.dart';

part 'signup_otp_verify_event.dart';
part 'signup_otp_verify_state.dart';

class SignUpOtpVerifyBloc
    extends Bloc<SignUpOtpVerifyEvent, SignUpOtpVerifyState> {
  SignUpOtpVerifyBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignUpOtpVerifyIdleState()) {
    on<SignUpOtpVerifyRequestEvent>(_onSignUpOtpVerifyUser);
    on<ResendOtpCodeRequestEvent>(_onResendSignUpOtp);
  }

  final AuthRepository _authRepository;

  Future<void> _onSignUpOtpVerifyUser(SignUpOtpVerifyRequestEvent event,
      Emitter<SignUpOtpVerifyState> emit) async {
    final signUpOtpVerifyFormValidationResponse =
        SignUpOtpVerifyFormValidationModel(
                email: event.email, otpCode: event.otpCode)
            .validate();
    if (signUpOtpVerifyFormValidationResponse != null) {
      emit(SignUpOtpVerifyFormValidationErrorState(
          signUpOtpVerifyFormValidationResponse));
      return;
    }

    emit(SigningUpOtpVerifingState());
    final response =
        await _authRepository.verifySignUpOtp(event.email, event.otpCode);
    response.when(success: (verificationResponse) {
      emit(SignedUpOtpVerifedState(verificationResponse.message));
    }, error: (error) {
      emit(SignUpOtpVerifyMessageState(error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _onResendSignUpOtp(ResendOtpCodeRequestEvent event,
      Emitter<SignUpOtpVerifyState> emit) async {
    final signUpOtpResendValidationResponse =
        SignUpOtpResendValidationModel(email: event.email).validate();
    if (signUpOtpResendValidationResponse != null) {
      emit(SignUpOtpVerifyMessageState(
          signUpOtpResendValidationResponse.formattedErrorMessage,
          SnackbarStyle.error));
      return;
    }

    emit(SigningUpOtpVerifingState());
    final response = await _authRepository.resendSignUpOtp(event.email);
    response.when(success: (response) {
      emit(OtpCodeResentState(response.message));
    }, error: (error) {
      emit(SignUpOtpVerifyMessageState(error.toMessage(), SnackbarStyle.error));
    });
  }
}
