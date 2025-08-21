import 'package:echowater/base/utils/strings.dart';

class ResetPasswordFormValidationModel {
  // Constructor with fields initialization
  ResetPasswordFormValidationModel({
    required String email,
    required String otpCode,
    required String password,
    required String confirmPassword,
  })  : _email = email,
        _otpCode = otpCode,
        _password = password,
        _confirmPassword = confirmPassword;

  // Private fields
  final String _email;
  final String _otpCode;
  final String _password;
  final String _confirmPassword;

  // Map to hold validation error messages
  final Map<String, String> _validationErrors = {};

  // Constants for error message keys
  static const String invalidEmailError = 'ResetPassword_invalid_email';
  static const String invalidOtpCodeError = 'ResetPassword_invalid_otpcode';
  static const String invalidPasswordError = 'ResetPassword_invalid_password';
  static const String invalidConfirmPasswordError = 'ResetPassword_invalid_confirm_password';

  // Getters
  String get email => _email.trim();
  String get otpCode => _otpCode;
  String get password => _password;
  String get confirmPassword => _confirmPassword;

  // Check if there are any validation errors
  bool get hasError => _validationErrors.isNotEmpty;

  // Formatted error message combining all validation errors
  String get formattedErrorMessage {
    return _validationErrors.values.join('\n');
  }

  // Specific error checks
  bool get hasEmailError => _validationErrors.containsKey(invalidEmailError);
  bool get hasOtpCodeError => _validationErrors.containsKey(invalidOtpCodeError);
  bool get hasPasswordError => _validationErrors.containsKey(invalidPasswordError);
  bool get hasConfirmPasswordError => _validationErrors.containsKey(invalidConfirmPasswordError);

  // Validate the model and return the instance if there are errors
  void validate() {
    _validationErrors.clear(); // Clear previous errors

    _validateEmail();
    _validateOtpCode();
    _validatePassword();
  }

  // Validate email field
  void _validateEmail() {
    if (email.isInvalidEmail) {
      _validationErrors[invalidEmailError] = invalidEmailError.localized;
    }
  }

  // Validate OTP code field
  void _validateOtpCode() {
    if (otpCode.isEmpty) {
      _validationErrors[invalidOtpCodeError] = invalidOtpCodeError.localized;
    }
  }

  // Validate password field
  void _validatePassword() {
    if (password.isInValidPassword) {
      _validationErrors[invalidPasswordError] = invalidPasswordError.localized;
    } else {
      _validateConfirmPassword();
    }
  }

  // Validate confirm password field
  void _validateConfirmPassword() {
    if (password != confirmPassword) {
      _validationErrors[invalidConfirmPasswordError] = invalidConfirmPasswordError.localized;
    }
  }
}
