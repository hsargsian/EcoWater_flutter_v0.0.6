import 'package:echowater/base/common_widgets/image_widgets/app_image_view.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/social_goal_domain.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../base/utils/colors.dart';
import '../../../core/domain/domain_models/social_goal_participant_domain.dart';

class SingleSocialGoalItemView extends StatelessWidget {
  const SingleSocialGoalItemView(
      {required this.goal,
      required this.hasBottomBorder,
      required this.isFromGoalScreen,
      this.onMoreOptionButtonClick,
      this.onSendReminderButtonClick,
      super.key});

  final SocialGoalDomain goal;
  final bool hasBottomBorder;
  final Function(SocialGoalDomain)? onMoreOptionButtonClick;
  final Function(SocialGoalDomain)? onSendReminderButtonClick;
  final bool isFromGoalScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: hasBottomBorder
                      ? AppColors.color717171
                      : Colors.transparent,
                  width: hasBottomBorder ? 0.5 : 0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 3,
                  child: Text(
                    goal.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w400),
                  )),
              isFromGoalScreen
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () {
                              onMoreOptionButtonClick?.call(goal);
                            },
                            icon: Icon(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryElementColor,
                                Icons.more_vert)),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
          Row(
            children: goal.daysDomain.map((item) {
              return Expanded(
                  child: Column(
                children: [
                  Text(item.dayInitial,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryElementColor)),
                  const SizedBox(
                    height: 3,
                  ),
                  Icon(
                    Icons.check_circle,
                    color: item.isAcheived
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .secondaryElementColor
                            .withValues(alpha: 0.5),
                  )
                ],
              ));
            }).toList(),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                  child: Center(
                child: isFromGoalScreen
                    ? _userView(goal.me, true, goal.isAchievedByMe(), context)
                    : _friendView(
                        goal.participants[1], goal.isAchievedByMe(), context),
              )),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    goal.totalText,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    goal.goalTypeText,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryElementColor),
                  ),
                  isFromGoalScreen
                      ? Builder(builder: (context) {
                          final isReminderSent = goal.haveISentReminder();
                          return Column(
                            children: [
                              const SizedBox(
                                height: 3,
                              ),
                              SvgPicture.asset(
                                Images.handshakeIconSVG,
                                width: 20,
                                colorFilter: ColorFilter.mode(
                                    isReminderSent
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondaryElementColor,
                                    BlendMode.srcIn),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Visibility(
                                visible: goal.canRemindPartner,
                                child: ColoredBox(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      onSendReminderButtonClick?.call(goal);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        isReminderSent
                                            ? 'SocialGoals_reminder_sent'
                                                .localized
                                            : 'SocialGoals_reminder_send'
                                                .localized,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                color: isReminderSent
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondaryElementColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        })
                      : const SizedBox.shrink()
                ],
              )),
              Expanded(
                  child: Center(
                child: _userView(goal.otherParticipant()?.participantUserDomain,
                    false, goal.isAchievedByOtherParticipant(), context),
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget _userView(
      UserDomain? user, bool isMe, bool hasAchieved, BuildContext context) {
    return user == null
        ? const SizedBox.shrink()
        : Column(
            children: [
              AppImageView(
                width: 60,
                height: 60,
                placeholderImage: Images.userPlaceholder,
                placeholderHeight: 60,
                placeholderWidth: 60,
                avatarUrl: user.primaryImageUrl(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(isMe ? 'You'.localized : user.firstName,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w400)),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    size: 20,
                    Icons.check_circle,
                    color: hasAchieved
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .secondaryElementColor
                            .withValues(alpha: 0.5),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Today'.localized,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryElementColor),
                  ),
                ],
              )
            ],
          );
  }

  Widget _friendView(SocialGoalParticipantDomain? user, bool hasAchieved,
      BuildContext context) {
    return user == null
        ? const SizedBox.shrink()
        : Column(
            children: [
              AppImageView(
                width: 60,
                height: 60,
                avatarUrl: user.participantUserDomain.userEntity.avatarImage,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(user.participantUserDomain.firstName),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    size: 20,
                    Icons.check_circle,
                    color: hasAchieved
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .secondaryElementColor
                            .withValues(alpha: 0.5),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Today'.localized,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryElementColor),
                  ),
                ],
              )
            ],
          );
  }
}
