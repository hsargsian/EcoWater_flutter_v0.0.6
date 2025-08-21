import 'package:echowater/base/utils/strings.dart';

class ChangePasswordFormValidationModel {
  ChangePasswordFormValidationModel(
      this._currentPassword, this._newPassword, this._confirmPassword);
  final String _currentPassword;
  final String _newPassword;
  final String _confirmPassword;

  bool passwordInputValidationError = false;

  final List<String> validationError = [];

  bool get hasError {
    return passwordInputValidationError;
  }

  String get formattederrorMessage {
    return validationError.map((e) => e.localized).join('\n');
  }

  ChangePasswordFormValidationModel? validate() {
    if ((_currentPassword.isEmpty) ||
        (_newPassword.isEmpty) ||
        (_confirmPassword.isEmpty)) {
      passwordInputValidationError = true;
      validationError.add('ChangePasswordScreen_emptyFieldValidation');
    }
    if ((_currentPassword.isInValidPassword) ||
        (_newPassword.isInValidPassword) ||
        (_confirmPassword.isInValidPassword)) {
      passwordInputValidationError = true;
      validationError
          .add('ChangePasswordScreen_validation_invalidPasswordField');
    }
    if (_newPassword != _confirmPassword) {
      passwordInputValidationError = true;
      validationError.add(
          'ChangePasswordScreen_validation_newAndConfirm_passwordNotmatch');
    }
    return hasError ? this : null;
  }
}
