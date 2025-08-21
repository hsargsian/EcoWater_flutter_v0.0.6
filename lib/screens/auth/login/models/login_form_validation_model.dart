import 'package:echowater/base/utils/strings.dart';

class LoginRequestModel {
  // Constructor with trimmed email and raw password
  LoginRequestModel({
    required String email,
    required String password,
  })  : _email = email,
        _password = password;

  // Private fields for email and password
  final String _email;
  final String _password;

  // Map to hold validation error messages
  final Map<String, String> _validationErrors = {};

  // Constants for error message keys
  static const String invalidEmailError =
      'LoginScreen_validation_emailValidation_message';
  static const String invalidPasswordError =
      'LoginScreen_validation_passwordValidation_message';

  // Getters for email and password
  String get email => _email.trim();
  String get password => _password.trim();

  // Check if there are any validation errors
  bool get hasError => _validationErrors.isNotEmpty;

  // Formatted error message combining all validation errors
  String get formattedErrorMessage {
    return _validationErrors.values.join('\n');
  }

  bool get hasEmailError => _validationErrors.containsKey(invalidEmailError);
  bool get hasPasswordError =>
      _validationErrors.containsKey(invalidPasswordError);

  // Validate the model and return the instance if there are errors
  void validate() {
    _validationErrors.clear(); // Clear previous errors

    _validateEmail();
    _validatePassword();
  }

  // Validate email field
  void _validateEmail() {
    if (email.isInvalidEmail) {
      _validationErrors[invalidEmailError] = invalidEmailError.localized;
    }
  }

  // Validate password field
  void _validatePassword() {
    if (password.isEmpty) {
      _validationErrors[invalidPasswordError] = invalidPasswordError.localized;
    }
  }
}
