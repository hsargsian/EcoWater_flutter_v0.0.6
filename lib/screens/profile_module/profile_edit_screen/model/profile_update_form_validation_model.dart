import 'package:echowater/base/utils/strings.dart';

class ProfileUpdateFormValidationModel {
  ProfileUpdateFormValidationModel(
      this.firstName, this.lastName, this.phoneNumber);
  final String firstName;
  final String lastName;
  final String phoneNumber;

  bool firstNameInputValidationError = false;
  bool lastNameInputValidationError = false;
  bool phoneNumberInputValidationError = false;
  List<String> validationErrors = [];

  bool get hasError {
    return firstNameInputValidationError ||
        lastNameInputValidationError ||
        phoneNumberInputValidationError;
  }

  String get formattedErrorMessage {
    return validationErrors.map((e) => e.localized).join('\n');
  }

  ProfileUpdateFormValidationModel? validate() {
    if (firstName.isEmpty) {
      firstNameInputValidationError = true;
      validationErrors
          .add('ProfileEditScreen_firstNameValidationError'.localized);
    }

    if (lastName.isEmpty) {
      lastNameInputValidationError = true;
      validationErrors
          .add('ProfileEditScreen_lastNameValidationError'.localized);
    }

    if (phoneNumber.isEmpty) {
      phoneNumberInputValidationError = true;
      validationErrors
          .add('ProfileEditScreen_phoneNumberValidationError'.localized);
    }

    return hasError ? this : null;
  }
}
