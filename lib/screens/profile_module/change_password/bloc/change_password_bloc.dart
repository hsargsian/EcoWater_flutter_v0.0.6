import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/repositories/user_repository.dart';
import '../model/change_password_form_validation_model.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ChangePasswordIdleState()) {
    on<ChangePasswordRequestEvent>(_onSubmitted);
  }

  final UserRepository _userRepository;

  Future<void> _onSubmitted(
    ChangePasswordRequestEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    final changePasswordValidationResponse = ChangePasswordFormValidationModel(
            event.currentPassword, event.newPassword, event.confirmPassword)
        .validate();
    if (changePasswordValidationResponse != null) {
      emit(ChangePasswordValidationError(changePasswordValidationResponse));
      return;
    }

    emit(ChangePasswordRequestingState());
    final response = await _userRepository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword);
    response.when(success: (changePasswordResponse) {
      emit(ChangePasswordRequestedState(changePasswordResponse.message));
    }, error: (error) {
      emit(ChangePassswordApiErrorState(error.toMessage()));
    });
  }
}
