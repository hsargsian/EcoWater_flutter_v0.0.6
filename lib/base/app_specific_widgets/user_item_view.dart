import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:flutter/material.dart';

import '../../screens/friends/friends_profile/friends_profile_screen.dart';
import '../common_widgets/image_widgets/app_image_view.dart';
import 'gradient_text.dart';

class UserItemView extends StatelessWidget {
  const UserItemView(
      {required this.user,
      required this.isSelected,
      required this.isSelectingFriend,
      this.onUnFriendButtonClick,
      this.onSelection,
      super.key});
  final UserDomain user;
  final Function(UserDomain user)? onUnFriendButtonClick;
  final Function(UserDomain user)? onSelection;
  final bool isSelected;
  final bool isSelectingFriend;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          _onFriendSelected(context);
        },
        child: Row(
          children: [
            AppImageView(
              avatarUrl: user.primaryImageUrl(),
              width: 50,
              height: 50,
              cornerRadius: 60,
              placeholderHeight: 74,
              placeholderWidth: 74,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              user.name,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const Spacer(),
            _getFriendActionButton(context)
          ],
        ));
  }

  void _onFriendSelected(BuildContext context) {
    if (isSelectingFriend) {
      onSelection?.call(user);
      return;
    }
    Navigator.push(context, FriendsProfileScreen.route(user.id));
  }

  Widget _getFriendActionButton(BuildContext context) {
    if (user.isMe) {
      return const SizedBox.shrink();
    }
    if (isSelectingFriend) {
      return IconButton(
          onPressed: () {
            _onFriendSelected(context);
          },
          icon: Icon(isSelected
              ? Icons.radio_button_checked
              : Icons.radio_button_off_outlined));
    }

    return user.friendStatus == FriendAction.friend.name
        ? InkWell(
            onTap: () {
              onUnFriendButtonClick?.call(user);
            },
            child: GradientText(
              user.friendActionTitle(),
              gradient: const LinearGradient(colors: [
                Color.fromRGBO(3, 162, 177, 0.95),
                Color.fromRGBO(99, 162, 178, 1),
                Color.fromRGBO(195, 162, 179, 0.93),
              ]),
            ),
          )
        : IconButton(
            onPressed: () {
              Navigator.push(context, FriendsProfileScreen.route(user.id));
            },
            icon: const Icon(Icons.arrow_forward_ios_sharp));
  }
}
