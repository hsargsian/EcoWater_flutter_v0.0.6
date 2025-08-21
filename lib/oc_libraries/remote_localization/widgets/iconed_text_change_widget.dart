import 'package:flutter/material.dart';

import '../firebase_localization/firebase_remote_localization_service.dart';
import '../remote_localization_service.dart';

class IconedTextChangeWidget extends StatefulWidget {
  const IconedTextChangeWidget({required this.service, super.key});
  final RemoteLocalizationService service;

  @override
  State<IconedTextChangeWidget> createState() => _IconedTextChangeWidgetState();
}

class _IconedTextChangeWidgetState extends State<IconedTextChangeWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onShowLocaleChangeSheet,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(widget.service.selectedLocale.languageCode),
        ),
      ),
    );
  }

  void _onShowLocaleChangeSheet() {
    FirebaseRemoteLocalizationService().showLocaleChangeSheet(context);
  }
}
