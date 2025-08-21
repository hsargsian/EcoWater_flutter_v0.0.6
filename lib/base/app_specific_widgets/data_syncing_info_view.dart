import 'package:flutter/material.dart';

import '../../oc_libraries/ble_service/ble_manager.dart';

class DataSyncingInfoView extends StatefulWidget {
  const DataSyncingInfoView({super.key});

  @override
  State<DataSyncingInfoView> createState() => _DataSyncingInfoViewState();
}

class _DataSyncingInfoViewState extends State<DataSyncingInfoView> {
  bool _showsInfoView = false;
  String _message = '';
  @override
  void initState() {
    super.initState();
    BleManager().onDataLogRequestChange = (message, flag) {
      _message = message;
      _showsInfoView = flag && message.isNotEmpty;
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_showsInfoView) {
      return Container();
    }
    return ColoredBox(
      color: Theme.of(context).colorScheme.tertiary,
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    color: Colors.green,
                    child: Text(_message),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
