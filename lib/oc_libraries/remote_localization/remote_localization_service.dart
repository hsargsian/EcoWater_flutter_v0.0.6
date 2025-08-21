import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'locale_data.dart';

abstract class RemoteLocalizationService {
  late AssetLoader assetLoader;
  Future<void> initService();
  Future<void> updateLocale(BuildContext context, LocaleData locale);
  List<Locale> getLocales();
  Future<void> showLocaleChangeSheet(
    BuildContext context,
  );
  late LocaleData selectedLocale;
}
