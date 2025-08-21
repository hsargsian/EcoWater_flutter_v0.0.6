import 'package:echowater/base/utils/strings.dart';

class ForgotPasswordValidationModel {
  // Constructor with raw email
  ForgotPasswordValidationModel({required String email}) : _email = email;

  // Private field for email
  final String _email;

  // Map to hold validation error messages
  final Map<String, String> _validationErrors = {};

  // Constants for error message keys
  static const String invalidEmailError = 'invalid_email_address';

  // Getters
  String get email => _email.trim();

  // Check if there are any validation errors
  bool get hasError => _validationErrors.isNotEmpty;

  // Formatted error message combining all validation errors
  String get formattedErrorMessage {
    return _validationErrors.values.join('\n');
  }

  bool get hasEmailError => _validationErrors.containsKey(invalidEmailError);

  // Validate the model and return the instance if there are errors
  void validate() {
    _validationErrors.clear(); // Clear previous errors

    _validateEmail();
  }

  // Validate email field
  void _validateEmail() {
    if (email.isInvalidEmail) {
      _validationErrors[invalidEmailError] = invalidEmailError.localized;
    }
  }
}
