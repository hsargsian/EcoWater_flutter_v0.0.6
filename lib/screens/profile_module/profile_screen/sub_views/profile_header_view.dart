import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_wrapper.dart';
import 'package:echowater/screens/friends/friends_listing_screen/friends_listing_screen.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../base/common_widgets/image_widgets/app_image_view.dart';
import '../../../../core/domain/domain_models/user_domain.dart';
import '../../../../core/services/walkthrough_manager/walk_through_item.dart';
import '../../../../core/services/walkthrough_manager/walk_through_manager.dart';
import '../../../friends/friends_profile/more_option/more_option_screen.dart';

class ProfileHeaderView extends StatelessWidget {
  const ProfileHeaderView(
      {required this.user,
      required this.canEditProfile,
      this.onAddFriendButtonClick,
      this.unFriendButtonClick,
      this.onEditClick,
      this.onReportProfile,
      this.deleteFriendRequestButtonClick,
      this.cancelFriendRequestButtonClick,
      super.key});
  final UserDomain? user;
  final bool canEditProfile;
  final Function()? onEditClick;
  final Function()? onAddFriendButtonClick;
  final Function()? unFriendButtonClick;
  final Function()? onReportProfile;
  final Function()? deleteFriendRequestButtonClick;
  final Function()? cancelFriendRequestButtonClick;

  @override
  Widget build(BuildContext context) {
    return user == null
        ? const SizedBox.shrink()
        : AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                AppImageView(
                  avatarUrl: user?.primaryImageUrl(),
                  width: 74,
                  height: 74,
                  cornerRadius: 60,
                  placeholderImage: Images.userPlaceholder,
                  placeholderHeight: 74,
                  placeholderWidth: 74,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  user?.name ?? '-',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: StringConstants.fieldGothicTestFont,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user?.email ?? '-',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color:
                          Theme.of(context).colorScheme.secondaryElementColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _getStatItem(context, user?.streaks ?? '-',
                        'ProfileHeader_streak'.localized, () {}),
                    const SizedBox(
                      width: 20,
                    ),
                    _getStatItem(context, user?.friendCount ?? '-',
                        'ProfileHeader_friends'.localized, () {
                      if (canEditProfile) {
                        Utilities.showBottomSheet(
                            widget: FriendsListingScreen(
                              showsFriendRequests: canEditProfile,
                              isSelectingFriend: false,
                            ),
                            context: context);
                      }
                    })
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    (user?.isMe ?? true)
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  title: user?.friendActionTitle() ?? '',
                                  hasGradientBackground: user?.friendStatus !=
                                      FriendAction.friend.name,
                                  hasGradientBorder: user?.friendStatus ==
                                      FriendAction.friend.name,
                                  backgroundColor: (user?.friendStatus ==
                                          FriendAction.friend.name)
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : Theme.of(context).colorScheme.primary,
                                  icon: (user?.friendStatus ==
                                          FriendAction.friend.name)
                                      ? SvgPicture.asset(
                                          Images.friendRight,
                                          width: 14,
                                          height: 14,
                                        )
                                      : const Icon(Icons.person),
                                  onClick: () {
                                    if (user!.friendStatus.isEmpty) {
                                      onAddFriendButtonClick?.call();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              user?.friendStatus == FriendAction.friend.name ||
                                      user?.friendStatus ==
                                          FriendAction.requestReceived.name ||
                                      user?.friendStatus ==
                                          FriendAction.requestSent.name
                                  ? AppButton(
                                      width: 40,
                                      radius: 40,
                                      onClick: () {
                                        _showMoreOptionBottomSheet(
                                          context,
                                        );
                                      },
                                      backgroundColor: Colors.black,
                                      hasGradientBorder: true,
                                      icon: SvgPicture.asset(
                                          Images.moreHorizontal),
                                      title: '',
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                  ],
                ),
                if (canEditProfile)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: WalkThroughWrapper(
                      hasWalkThough:
                          WalkThroughManager().currentWalkthroughItem ==
                              WalkThroughItem.profileEditProfile,
                      clipRadius: 30,
                      radius: 30,
                      child: Padding(
                        padding: WalkThroughManager().currentWalkthroughItem ==
                                WalkThroughItem.profileEditProfile
                            ? const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2)
                            : EdgeInsets.zero,
                        child: AppButton(
                            icon: SvgPicture.asset(Images.editIcon),
                            hasGradientBorder: true,
                            title: 'ProfileScreen_EditProfile'.localized,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            onClick: () {
                              onEditClick?.call();
                            }),
                      ),
                    ),
                  ),
              ],
            ),
          );
  }

  Widget _getStatItem(
      BuildContext context, String title, String body, Function()? onClick) {
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            body,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }

  void _showMoreOptionBottomSheet(BuildContext context) {
    Utilities.showBottomSheet(
        widget: MoreOptionScreen(
          user: user,
          onReportProfile: onReportProfile,
          unFriendButtonClick: unFriendButtonClick,
          deleteFriendRequestButtonClick: deleteFriendRequestButtonClick,
          cancelFriendRequestButtonClick: cancelFriendRequestButtonClick,
        ),
        context: context);
  }
}
