import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/core/services/api_log_service.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import '../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../base/common_widgets/navbar/nav_bar.dart';

class DataTrackingLogScreen extends StatefulWidget {
  const DataTrackingLogScreen({super.key});

  @override
  State<DataTrackingLogScreen> createState() => _DataTrackingLogScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/DataTrackingLogScreen'),
        builder: (_) => const DataTrackingLogScreen());
  }
}

class _DataTrackingLogScreenState extends State<DataTrackingLogScreen> {
  late final ApiLogService _logService;

  @override
  void initState() {
    _logService = Injector.instance<ApiLogService>();
    super.initState();
    _logService.dataSyncLogsNotifier.addListener(_updateUI);
  }

  void _updateUI() {
    if (mounted) {
      setState(() {}); // Triggers UI rebuild when logs change
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EchoWaterNavBar(
            child: NavBar(
                navStyle: NavStyle.singleLined,
                navTitle: 'Data Tracking Logs',
                textColor: Theme.of(context).colorScheme.primaryElementColor,
                leftButton: LeftArrowBackButton(
                  onButtonPressed: () {
                    Navigator.pop(context);
                  },
                ),
                sideMenuItems: [
              IconButton(
                  onPressed: () {
                    _logService.shareDataSyncLog();
                  },
                  icon: const Icon(Icons.share_sharp)),
              IconButton(
                  onPressed: () {
                    _logService.clearDataSyncLog();
                  },
                  icon: const Icon(Icons.clear))
            ])),
        body: logView());
  }

  Widget logView() {
    return ListView.builder(
        itemCount: _logService.dataSyncLogsNotifier.value.length,
        itemBuilder: (context, index) {
          final item = _logService.dataSyncLogsNotifier.value[index];
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ColoredBox(
                  color: Theme.of(context).colorScheme.tertiary,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['message']),
                        const SizedBox(
                          height: 3,
                        ),
                        if (item['date'] != null) Text(item['date'])
                      ],
                    ),
                  )));
        });
  }
}
