import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';

import '../../../../base/utils/colors.dart';
import '../../../../base/utils/utilities.dart';
import '../../../../core/domain/domain_models/user_domain.dart';
import '../report_profile/report_profile_screen.dart';

class MoreOptionScreen extends StatelessWidget {
  const MoreOptionScreen(
      {required this.user,
      this.unFriendButtonClick,
      this.onReportProfile,
      this.deleteFriendRequestButtonClick,
      this.cancelFriendRequestButtonClick,
      super.key});
  final UserDomain? user;
  final Function()? onReportProfile;
  final Function()? unFriendButtonClick;
  final Function()? deleteFriendRequestButtonClick;
  final Function()? cancelFriendRequestButtonClick;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.secondary,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.2),
        child: Column(
          children: [
            SizedBox(
              width: 50,
              child: Divider(thickness: 2, color: AppColors.color717171),
            ),
            InkWell(
              onTap: () {
                if (user?.friendStatus == FriendAction.requestReceived.name) {
                  deleteFriendRequestButtonClick?.call();
                } else if (user?.friendStatus ==
                    FriendAction.requestSent.name) {
                  cancelFriendRequestButtonClick?.call();
                } else {
                  unFriendButtonClick?.call();
                }

                Navigator.pop(context);
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_add_alt,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          friendTitle,
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.color717171,
                  ),
                ],
              ),
            ),
            isShowReportProfile
                ? const SizedBox.shrink()
                : Column(children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          if (user?.friendStatus == FriendAction.friend.name) {
                            _showReportProfileBottomSheet(context);
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              'ProfileScreenOption_reportProfile'.localized,
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: AppColors.color717171,
                    )
                  ])
          ],
        ),
      ),
    );
  }

  String get friendTitle {
    if (user?.friendStatus == FriendAction.requestReceived.name) {
      return 'Delete_request'.localized;
    } else if (user?.friendStatus == FriendAction.requestSent.name) {
      return 'Cancel_request'.localized;
    } else {
      return 'Unfriend'.localized;
    }
  }

  bool get isShowReportProfile {
    if (user?.friendStatus == FriendAction.requestSent.name) {
      return true;
    } else if (user?.friendStatus == FriendAction.requestReceived.name) {
      return true;
    } else {
      return false;
    }
  }

  void _showReportProfileBottomSheet(BuildContext context) {
    Utilities.showBottomSheet(
        widget: ReportProfileScreen(
          name: user?.name ?? '-',
          onReportProfile: onReportProfile,
        ),
        context: context);
  }
}
