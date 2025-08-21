import 'package:echowater/base/utils/strings.dart';

class SignUpOtpVerifyFormValidationModel {
  SignUpOtpVerifyFormValidationModel(
      {required this.email, required this.otpCode});
  final String email;
  final String otpCode;
  bool emailInputValidationError = false;
  bool otpCodeInputValidationError = false;
  final List<String> validationErrors = [];

  bool get hasError {
    return emailInputValidationError || otpCodeInputValidationError;
  }

  String get formattedErrorMessage {
    return validationErrors.map((e) => e.localized).join('\n');
  }

  SignUpOtpVerifyFormValidationModel? validate() {
    if (email.isInvalidEmail) {
      emailInputValidationError = true;
      validationErrors.add('SignUp_otp_screen_invalid_email'.localized);
    }
    if (otpCode.isEmpty) {
      otpCodeInputValidationError = true;
      validationErrors.add('SignUp_otp_screen_invalid_otpcode'.localized);
    }
    return hasError ? this : null;
  }
}
