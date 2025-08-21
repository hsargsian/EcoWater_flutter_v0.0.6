import 'package:echowater/base/utils/strings.dart';

class SignUpOtpResendValidationModel {
  SignUpOtpResendValidationModel({required this.email});
  final String email;
  bool emailInputValidationError = false;
  final List<String> validationErrors = [];

  bool get hasError {
    return emailInputValidationError;
  }

  String get formattedErrorMessage {
    return validationErrors.map((e) => e.localized).join('\n');
  }

  SignUpOtpResendValidationModel? validate() {
    if (email.isInvalidEmail) {
      emailInputValidationError = true;
      validationErrors.add('SignUp_otp_screen_invalid_email'.localized);
    }

    return hasError ? this : null;
  }
}
