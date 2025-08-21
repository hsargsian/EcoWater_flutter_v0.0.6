import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../../core/api/resource/resource.dart';
import '../../../../core/domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import '../../../../core/domain/repositories/auth_repository.dart';
import '../model/reset_password_form_validation_model.dart';
import '../model/reset_password_otp_resend_validation_model.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(ResetPasswordIdleState()) {
    on<ResetPasswordRequestEvent>(_onResetPassword);
    on<ResendOtpCodeRequestEvent>(_onResendSignUpOtp);
  }

  final AuthRepository _authRepository;

  Future<void> _onResetPassword(
      ResetPasswordRequestEvent event, Emitter<ResetPasswordState> emit) async {
    // Create and validate the validation model
    final validationModel = _createValidationModelAndValidate(event);

    // If validation errors exist, emit error state and exit
    if (validationModel.hasError) {
      emit(ResetPasswordFormValidationErrorState(validationModel));
      return;
    }
    emit(ResetingPasswordState());
    // Perform the reset password request and handle the response
    final response = await _requestResetPassword(
      validationModel.email,
      validationModel.password,
      validationModel.confirmPassword,
      validationModel.otpCode,
    );
    _handleResetPasswordResponse(response, emit);
  }

  // Perform the reset password request
  Future<Result<ApiSuccessMessageResponseEntity>> _requestResetPassword(
      String email,
      String newPassword,
      String confirmPassword,
      String otpCode) async {
    return _authRepository.resetPassword(
      email,
      newPassword,
      confirmPassword,
      otpCode,
    );
  }

// Handle the reset password response
  void _handleResetPasswordResponse(
      Result<ApiSuccessMessageResponseEntity> response,
      Emitter<ResetPasswordState> emit) {
    response.when(
      success: (verificationResponse) {
        emit(PasswordResetSuccessfulState(verificationResponse.message));
      },
      error: (error) {
        emit(ResetPasswordMessageState(error.toMessage(), SnackbarStyle.error));
      },
    );
  }

  // Helper method to create the validation model
  ResetPasswordFormValidationModel _createValidationModelAndValidate(
      ResetPasswordRequestEvent event) {
    return ResetPasswordFormValidationModel(
        email: event.email,
        password: event.newPassword,
        confirmPassword: event.confirmPassword,
        otpCode: event.otpCode)
      ..validate();
  }

  Future<void> _onResendSignUpOtp(
      ResendOtpCodeRequestEvent event, Emitter<ResetPasswordState> emit) async {
    final otpResendValidationResponse =
        OtpResendValidationModel(email: event.email).validate();
    if (otpResendValidationResponse != null) {
      emit(ResetPasswordMessageState(
          otpResendValidationResponse.formattedErrorMessage,
          SnackbarStyle.validationError));
      return;
    }

    emit(ResetingPasswordState());
    final response =
        await _authRepository.requestResendResetPasswordOtpCode(event.email);
    response.when(success: (response) {
      emit(OtpCodeResentState(response.message));
    }, error: (error) {
      emit(ResetPasswordMessageState(error.toMessage(), SnackbarStyle.error));
    });
  }
}
