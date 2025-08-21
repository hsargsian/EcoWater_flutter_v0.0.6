import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/localization.dart';

import 'package:flutter/material.dart';

import '../locale_data.dart';
import '../remote_localization_service.dart';
import 'firebase_localization_loader.dart';

class FirebaseRemoteLocalizationService implements RemoteLocalizationService {
  factory FirebaseRemoteLocalizationService() {
    _instance = _instance ?? FirebaseRemoteLocalizationService._internal();
    return _instance!;
  }
  FirebaseRemoteLocalizationService._internal();
  final _fireStore = FirebaseFirestore.instance;
  @override
  AssetLoader assetLoader = FirebaseLocalizationLoader();

  static FirebaseRemoteLocalizationService? _instance;

  Function()? onLocaleChanged;

  List<LocaleData> supportedLocaleData = [
    LocaleData(language: 'English', languageCode: 'en', countryCode: 'US')
  ];

  @override
  LocaleData selectedLocale =
      LocaleData(language: 'English', languageCode: 'en', countryCode: 'US');

  @override
  Future<void> initService() async {
    (assetLoader as FirebaseLocalizationLoader).fireStore = _fireStore;
    await _fetchSupportedLocalization();
    return Future.value();
  }

  @override
  List<Locale> getLocales() {
    return supportedLocaleData.map((e) => e.locale).toList();
  }

  Future<void> _fetchSupportedLocalization() async {
    final languageSupportsSnapshot = await _fireStore
        .collection('app_informations')
        .doc('localization_support')
        .get();

    final languageSupportsData = languageSupportsSnapshot.data();

    if (languageSupportsData != null) {
      final List<Map<String, dynamic>>? languageSupports =
          languageSupportsData['languages']?.cast<Map<String, dynamic>>();

      final newLocales = languageSupports
          ?.where((item) =>
              item['languageCode'] != null &&
              item['countryCode'] != null &&
              item['language'] != null)
          .map((item) => LocaleData(
              language: item['language'],
              languageCode: item['languageCode'],
              countryCode: item['countryCode']))
          .toList();

      if (newLocales != null && newLocales.isNotEmpty) {
        supportedLocaleData = newLocales;
      }
    }
    return Future.value();
  }

  @override
  Future<void> updateLocale(BuildContext context, LocaleData locale) async {
    await context.setLocale(locale.locale);
    if (!context.mounted) {
      return Future.value();
    }
    final localizationController =
        EasyLocalization.of(context)?.delegate.localizationController;
    if (localizationController != null) {
      await localizationController.loadTranslations();
      Localization.load(
        locale.locale,
        translations: localizationController.translations,
        fallbackTranslations: localizationController.fallbackTranslations,
      );
      selectedLocale = locale;
      onLocaleChanged?.call();
    }

    return Future.value();
  }

  @override
  Future<void> showLocaleChangeSheet(
    BuildContext context,
  ) async {
    const itemHeight = 50.0;
    final selectedLocale = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Theme.of(context).bottomSheetTheme.modalBarrierColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        context: context,
        isScrollControlled: true,
        builder: (context) => ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9),
              child: SizedBox(
                height: (supportedLocaleData.length * itemHeight) + 120,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Choose Language',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pop(
                                  context, supportedLocaleData[index]);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              height: itemHeight,
                              child: Column(
                                children: [
                                  Text(
                                    '${supportedLocaleData[index].language}(${supportedLocaleData[index].languageCode})',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 0.5,
                                    color: Colors.black45,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: supportedLocaleData.length,
                      )
                    ],
                  ),
                ),
              ),
            ));
    if (context.mounted) {
      await FirebaseRemoteLocalizationService()
          .updateLocale(context, selectedLocale);
    }
  }
}
