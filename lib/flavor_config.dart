import 'base/utils/images.dart';

enum Flavor { dev, uat, production }

class FlavorValues {
  FlavorValues(
      {required this.baseUrl,
      required this.useAnalytics,
      required this.logsResponse,
      required this.clickUpApiKey,
      required this.clickUpListId,
      required this.klaviyoApiKey});
  final String baseUrl;
  final bool useAnalytics;
  final bool logsResponse;
  final String clickUpApiKey;
  final String clickUpListId;
  final String klaviyoApiKey;
}

class FlavorConfig {
  factory FlavorConfig({required Flavor flavor, required FlavorValues values}) {
    _inst.flavor = flavor;
    _inst.values = values;
    return _inst;
  }

  FlavorConfig._internal();
  late final Flavor flavor;
  late final FlavorValues values;
  static final FlavorConfig _inst = FlavorConfig._internal();

  static bool isProduction() => _inst.flavor == Flavor.production;
  static bool isNotProduction() => _inst.flavor != Flavor.production;
  static bool isDevelopment() => _inst.flavor == Flavor.dev;
  static bool isUAT() => _inst.flavor == Flavor.uat;
  static bool useAnalytics() => _inst.values.useAnalytics;
  static String baseUrl() => _inst.values.baseUrl;
  static bool logsResponse() => _inst.values.logsResponse;
  static String clickUpApiKey() => _inst.values.clickUpApiKey;
  static String clickUpListId() => _inst.values.clickUpListId;
  static String klaviyoApiKey() => _inst.values.klaviyoApiKey;

  static String envFile() {
    switch (_inst.flavor) {
      case Flavor.dev:
        return '.dev.env';
      case Flavor.uat:
        return '.uat.env';
      case Flavor.production:
        return '.prod.env';
    }
  }

  static String appIconImage() {
    switch (_inst.flavor) {
      case Flavor.dev:
        return Images.splashLogo;
      case Flavor.uat:
        return Images.splashLogo;
      case Flavor.production:
        return Images.splashLogo;
    }
  }
}
