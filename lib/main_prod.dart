import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'flavor_config.dart';
import 'main.dart' as main_file;

void main() async {
  await dotenv.load(fileName: '.prod.env');
  FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        baseUrl: dotenv.env['BASEURL']!,
        useAnalytics: true,
        logsResponse: false,
        clickUpApiKey: dotenv.env['CLICKUP_API_KEY']!,
        clickUpListId: dotenv.env['CLICKUP_LIST_ID']!,
        klaviyoApiKey: dotenv.env['KLAVIYO_API_KEY']!,
      ));
  main_file.main();
}
