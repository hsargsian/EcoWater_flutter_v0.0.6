import 'package:easy_localization/easy_localization.dart';

extension ExtString on String {
  bool get isInvalidEmail {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return !emailRegExp.hasMatch(this);
  }

  bool get isInvalidOTPCode {
    return length != 6;
  }

  bool get isInValidName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return !nameRegExp.hasMatch(this);
  }

  bool get isInvalidUrl {
    final urlRegExp = RegExp(
        r'^(?:http|https):\/\/' // scheme
        r'(?:(?:[A-Z0-9][A-Z0-9_-]*)(?:\.[A-Z0-9][A-Z0-9_-]*)+)' // domain
        r'(?::\d+)?' // port
        r'(?:\/[^\s]*)?' // path
        r'(?:\?[^\s]*)?' // query parameters
        r'(?:#[^\s]*)?$', // fragment
        caseSensitive: false);
    return urlRegExp.hasMatch(this);
  }

  bool get isInValidAlphabeticalText {
    final regExp = RegExp(r'^[a-zA-Z]+$');
    return !regExp.hasMatch(this);
  }

  bool get isInvalidUUId {
    // Define a regular expression to match a UUID pattern.
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
      caseSensitive: false,
    );

    // Check if the provided string matches the UUID pattern.
    return !uuidRegex.hasMatch(this);
  }

  String get stripHtmlTags {
    final exp = RegExp('<[^>]*>', multiLine: true, dotAll: true);
    return replaceAll(exp, '');
  }

  bool get isInValidPassword {
    final rexExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return !rexExp.hasMatch(this);
  }

  bool get isInValidPhone {
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,}$');
    return !phoneRegExp.hasMatch(this);
  }

  bool equalsTo(String secondString) {
    return this == secondString;
  }

  bool isNotEqualTo(String secondString) {
    return this != secondString;
  }

  String get localized => this.tr();
  String? get firstCharacter => isEmpty ? null : this[0];

  String capitalizeWords() {
    if (isEmpty) {
      return this;
    }

    return split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  String capitalizeFirst() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }

  String get initials {
    final items = split(' ')
        .map((e) => e.firstCharacter)
        .where((element) => element != null)
        .where((element) => element!.isNotEmpty)
        .toList();
    final length = items.length;
    if (items.isEmpty) {
      return '';
    } else if (length == 1) {
      return items.join();
    } else {
      return [items[0], items[length - 1]].join();
    }
  }
}
