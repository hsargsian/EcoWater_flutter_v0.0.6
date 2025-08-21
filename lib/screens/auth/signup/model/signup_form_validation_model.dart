import 'package:echowater/base/utils/strings.dart';

class SignUpFormValidationModel {
  SignUpFormValidationModel({
    required String name,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
  })  : _firstName = name,
        _lastName = lastName,
        _email = email,
        _password = password,
        _confirmPassword = confirmPassword,
        _phoneNumber = phoneNumber;

  // Fields
  final String _firstName;
  final String _lastName;
  final String _email;
  final String _password;
  final String _confirmPassword;
  final String _phoneNumber;

  // Constants for error message keys
  static const String invalidNameError = 'SignUp_invalid_name';
  static const String invalidLastNameError = 'SignUp_invalid_last_name';
  static const String invalidEmailError = 'SignUp_invalid_email';
  static const String invalidPasswordError = 'invalidPasswordError';
  static const String invalidConfirmPasswordError =
      'SignUp_invalid_confirm_password';
  static const String invalidPhoneNumberError = 'SignUp_invalid_phone_number';

  // Validation error map
  final Map<String, String> _validationErrors = {};

  bool get hasFirstNameError => _validationErrors.containsKey(invalidNameError);
  bool get hasLastNameError =>
      _validationErrors.containsKey(invalidLastNameError);
  bool get hasEmailError => _validationErrors.containsKey(invalidEmailError);
  bool get hasPasswordError =>
      _validationErrors.containsKey(invalidPasswordError);
  bool get hasConfirmPasswordError =>
      _validationErrors.containsKey(invalidConfirmPasswordError);

  String get firstName => _firstName.trim().capitalizeFirst();
  String get lastName => _lastName.trim().capitalizeFirst();
  String get email => _email.trim();
  String get password => _password.trim();
  String get confirmPassword => _confirmPassword.trim();
  String get phoneNumber => _phoneNumber.trim();

  bool get hasError => _validationErrors.isNotEmpty;

  String get formattedErrorMessage {
    return _validationErrors.values.join('\n');
  }

  void validate() {
    _validationErrors.clear();

    _validateName();
    _validateEmail();
    _validatePassword();
    _validateConfirmPassword();
    _validatePhoneNumber();
  }

  void _validateName() {
    if (firstName.isEmpty || firstName.isInValidAlphabeticalText) {
      _validationErrors[invalidNameError] = invalidNameError.localized;
    }
    if (lastName.isEmpty || lastName.isInValidAlphabeticalText) {
      _validationErrors[invalidLastNameError] = invalidLastNameError.localized;
    }
  }

  void _validateEmail() {
    if (email.isInvalidEmail) {
      _validationErrors[invalidEmailError] = invalidEmailError.localized;
    }
  }

  void _validatePassword() {
    if (password.isEmpty) {
      _validationErrors[invalidPasswordError] =
          'SignUp_invalid_empty_password'.localized;
    } else if (password.isInValidPassword) {
      _validationErrors[invalidPasswordError] =
          'SignUp_invalid_password'.localized;
    }
  }

  void _validateConfirmPassword() {
    if (confirmPassword != password) {
      _validationErrors[invalidConfirmPasswordError] =
          invalidConfirmPasswordError.localized;
    }
  }

  void _validatePhoneNumber() {
    if (phoneNumber.isEmpty) {
      _validationErrors[invalidPhoneNumberError] =
          invalidPhoneNumberError.localized;
    }
  }
}
