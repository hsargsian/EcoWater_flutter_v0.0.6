import 'package:country_picker/country_picker.dart';

class PhoneNumberModel {
  PhoneNumberModel(this.countryCode, this.phoneCode, this.phoneNumber, this.countryName);

  PhoneNumberModel.fromNumber(String number, List<Country> countries)
      : countryCode = _determineCountryCode(number, countries),
        phoneCode = _determinePhoneCode(number, countries),
        phoneNumber = _extractPhoneNumber(number, countries),
        countryName = _determineCountryName(number, countries);

  final String countryCode;
  final String countryName;
  final String phoneCode;
  final String phoneNumber;

  // Determine the country code from the given number
  static String _determineCountryCode(String number, List<Country> countries) {
    final cleanedNumber = number.cleanPhoneNumber;
    for (var country in countries) {
      if (cleanedNumber.startsWith(country.phoneCode)) {
        return country.countryCode;
      }
    }
    return 'US'; // Default to US if no match found
  }

  // Determine the phone code from the given number
  static String _determinePhoneCode(String number, List<Country> countries) {
    final cleanedNumber = number.cleanPhoneNumber;
    for (var country in countries) {
      if (cleanedNumber.startsWith(country.phoneCode)) {
        return country.phoneCode;
      }
    }
    return '+1'; // Default to +1 (USA) if no match found
  }

  // Extract the actual phone number (excluding the country code)
  static String _extractPhoneNumber(String number, List<Country> countries) {
    final cleanedNumber = number.cleanPhoneNumber;
    for (var country in countries) {
      if (cleanedNumber.startsWith(country.phoneCode)) {
        return cleanedNumber.substring(country.phoneCode.length);
      }
    }
    return cleanedNumber; // Fallback to entire number if no match found
  }

  static String _determineCountryName(String number, List<Country> countries) {
    var cleanedNumber = number.cleanPhoneNumber;
    for (var country in countries) {
      if (cleanedNumber.startsWith(country.phoneCode)) {
        cleanedNumber = country.displayName;
        return cleanedNumber;
      }
    }
    return cleanedNumber; // Fallback to entire number if no match found
  }
}

// String extension for phone number cleanup
extension ExtString on String {
  String get cleanPhoneNumber {
    return replaceAll('+', '').replaceAll(' ', '').replaceAll('-', ''); // Removes all non-numeric characters except "+"
  }
}
