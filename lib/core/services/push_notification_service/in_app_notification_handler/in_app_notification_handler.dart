import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

import '../../../../base/common_widgets/in_app_notification_view.dart';
import '../../../../screens/device_management/in_app_notification.dart';

class InAppNotificationOverlay {
  InAppNotificationOverlay({
    required this.id,
  });
  final String id;
  late final OverlayEntry overlay;
}

class InAppNotificationHandler {
  factory InAppNotificationHandler() {
    return _instance;
  }

  InAppNotificationHandler._internal();
  final List<InAppNotificationOverlay> _overlays = [];
  static final InAppNotificationHandler _instance =
      InAppNotificationHandler._internal();

  Future<void> showOverlay(BuildContext context,
      {required InAppNotification notification}) async {
    final overlayState = Overlay.of(context);
    final overlay = InAppNotificationOverlay(id: const Uuid().v4());
    final overlayEntry = OverlayEntry(builder: (context) {
      return InAppNotificationContent(
        overlay: overlay,
        notification: notification,
        onCloseClicked: (currentOverlay) {
          _removeOverlay(currentOverlay);
        },
        onNotificationClicked: (currentOverlay, notification) {
          _removeOverlay(currentOverlay);
          // Injector.instance<DashboardBloc>().add(InAppNotificationReceivedEvent(
          //     notification, NotificationAppState.onClick));
        },
      );
    });
    overlay.overlay = overlayEntry;
    _overlays.add(overlay);
    await _vibrate();
    overlayState.insert(overlayEntry);
  }

  void _removeOverlay(InAppNotificationOverlay overlay) {
    overlay.overlay.remove();
    _overlays.removeWhere((element) => element.id == overlay.id);
  }

  Future<void> _vibrate() async {
    final hasVibration = (await Vibration.hasVibrator()) ?? false;
    if (hasVibration) {
      await Vibration.vibrate();
    }
  }
}
