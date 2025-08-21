import 'package:flutter/material.dart';

class LocaleData {
  LocaleData(
      {required this.language,
      required this.languageCode,
      required this.countryCode});
  final String language;
  final String languageCode;
  final String countryCode;

  Locale get locale => Locale(languageCode, countryCode);
}
