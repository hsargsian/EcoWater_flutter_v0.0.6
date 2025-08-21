import 'package:flutter/material.dart';

import '../../core/services/push_notification_service/in_app_notification_handler/in_app_notification_handler.dart';
import '../../screens/device_management/in_app_notification.dart';
import '../constants/constants.dart';
import '../utils/colors.dart';
import 'image_widgets/app_image_view.dart';

class InAppNotificationContent extends StatefulWidget {
  const InAppNotificationContent(
      {required this.overlay,
      required this.notification,
      this.onCloseClicked,
      this.onNotificationClicked,
      super.key});
  final InAppNotificationOverlay overlay;
  final InAppNotification notification;
  final Function(InAppNotificationOverlay)? onCloseClicked;
  final Function(InAppNotificationOverlay, InAppNotification)?
      onNotificationClicked;

  @override
  State<InAppNotificationContent> createState() =>
      _InAppNotificationContentState();
}

class _InAppNotificationContentState extends State<InAppNotificationContent> {
  bool _showsNotification = false;
  bool _hasShownNotification = false;
  Future? overlayRemoveFuture;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 10)).whenComplete(() {
      setState(() {
        _showsNotification = true;
      });

      overlayRemoveFuture = Future.delayed(const Duration(
              seconds: Constants.inAppNotificationDuration, milliseconds: 510))
          .whenComplete(_closeNotification);
    });
  }

  void _closeNotification() {
    setState(() {
      _showsNotification = false;
    });
    _hasShownNotification = true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: 10,
      right: 10,
      top: _showsNotification ? 50 : -100,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: AppColors.transparent,
          child: _mainContent(),
        ),
      ),
      onEnd: () {
        if (_hasShownNotification) {
          widget.onCloseClicked?.call(widget.overlay);
        }
      },
    );
  }

  Widget _mainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: InkWell(
        onTap: () {
          overlayRemoveFuture?.ignore();
          _closeNotification();
          widget.onNotificationClicked
              ?.call(widget.overlay, widget.notification);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.8),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(1, 1), // changes position of shadow
                )
              ],
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const AppImageView(
                  width: 40,
                  height: 40,
                  cornerRadius: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.notification.notificationTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.notification.notificationBody,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    overlayRemoveFuture?.ignore();
                    _closeNotification();
                  },
                  iconSize: 15,
                  icon: const Icon(
                    Icons.close,
                    size: 15,
                  ),
                  color: AppColors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
