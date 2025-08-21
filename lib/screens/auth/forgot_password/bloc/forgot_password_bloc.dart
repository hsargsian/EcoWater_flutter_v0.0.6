import 'package:bloc/bloc.dart';

import '../../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../../core/api/resource/resource.dart';
import '../../../../core/domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import '../../../../core/domain/repositories/auth_repository.dart';
import '../model/forgot_password_validation_model.dart';
import 'forgot_password_event.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({required AuthRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(ForgotPasswordIdleState()) {
    on<ForgotPasswordRequestEvent>(_onSubmitted);
    on<ValidateButtonEvent>(_validateButton);
  }

  final AuthRepository _authenticationRepository;

  Future<void> _onSubmitted(
    ForgotPasswordRequestEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    // Create and validate the ForgotPasswordValidationModel
    final validationResponse = _createAndValidateModel(event.email);

    // If validation errors exist, emit error state and exit
    if (validationResponse.hasError) {
      emit(ForgotPasswordValidationError(validationResponse));
      return;
    }

    emit(ForgotPasswordRequestingState());

    // Perform the forgot password request and handle the response
    final response = await _requestForgotPassword(validationResponse.email);
    _handleForgotPasswordResponse(response, emit);
  }

// Create and validate ForgotPasswordValidationModel
  ForgotPasswordValidationModel _createAndValidateModel(String email) {
    return ForgotPasswordValidationModel(email: email)..validate();
  }

// Perform the forgot password request
  Future<Result<ApiSuccessMessageResponseEntity>> _requestForgotPassword(
      String email) async {
    return _authenticationRepository.requestForgotPassword(email);
  }

// Handle the forgot password response
  void _handleForgotPasswordResponse(
      Result<ApiSuccessMessageResponseEntity> response,
      Emitter<ForgotPasswordState> emit) {
    response.when(
      success: (forgotPasswordResponse) {
        emit(ForgotPasswordRequestedState(forgotPasswordResponse.message));
      },
      error: (error) {
        emit(
            ForgotPasswordMessageState(error.toMessage(), SnackbarStyle.error));
      },
    );
  }

  void _validateButton(
      ValidateButtonEvent event, Emitter<ForgotPasswordState> emit) {
    final forgotPasswordValidationResponse =
        _createAndValidateModel(event.email);
    if (forgotPasswordValidationResponse.hasError) {
      emit(ForgotPasswordValidationError(forgotPasswordValidationResponse));
    } else {
      emit(ForgotPasswordIdleState());
    }
  }
}
