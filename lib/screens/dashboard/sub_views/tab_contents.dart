import 'package:echowater/base/common_widgets/image_widgets/app_image_view.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/screens/home/home_screen.dart';
import 'package:echowater/screens/learning_module/learning_screen/learning_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../base/utils/colors.dart';
import '../../../base/utils/images.dart';
import '../../goals_module/goals_screen/goals_screen.dart';
import '../../profile_module/profile_screen/profile_screen.dart';
import '../../protocols/protocol_tab_dashboard_screen/protocol_tab_dashboard_screen.dart';

class DashboardPageItem {
  DashboardPageItem({
    required this.tab,
    this.badgeValue,
  });

  final DashboardTabs tab;
  final int? badgeValue;
}

enum DashboardTabs {
  home,
  goal,
  learning,
  protocols,
  profile;

  int get itemIndex {
    switch (this) {
      case DashboardTabs.home:
        return 0;

      case DashboardTabs.goal:
        return 1;
      case DashboardTabs.learning:
        return 2;
      case DashboardTabs.protocols:
        return 3;

      case DashboardTabs.profile:
        return 4;
    }
  }

  static List<DashboardTabs> getTabs() {
    return [
      DashboardTabs.home,
      DashboardTabs.goal,
      DashboardTabs.learning,
      DashboardTabs.protocols,
      DashboardTabs.profile
    ];
  }

  String get label {
    switch (this) {
      case DashboardTabs.home:
        return 'Tab_home'.localized;
      case DashboardTabs.profile:
        return 'Tab_profile'.localized;
      case DashboardTabs.learning:
        return 'Tab_learning'.localized;
      case DashboardTabs.protocols:
        return 'Tab_protocol'.localized;
      case DashboardTabs.goal:
        return 'Tab_goals'.localized;
    }
  }

  Widget icon(UserDomain? user) {
    switch (this) {
      case DashboardTabs.home:
        return SvgPicture.asset(
          Images.homeTabIcon,
          colorFilter:
              const ColorFilter.mode(AppColors.colorB3B3B3, BlendMode.srcIn),
          width: 25,
        );
      case DashboardTabs.goal:
        return SvgPicture.asset(
          Images.goalTabIcon,
          colorFilter:
              const ColorFilter.mode(AppColors.colorB3B3B3, BlendMode.srcIn),
          width: 25,
        );
      case DashboardTabs.learning:
        return SvgPicture.asset(
          Images.learningTabIcon,
          colorFilter:
              const ColorFilter.mode(AppColors.colorB3B3B3, BlendMode.srcIn),
          width: 25,
        );
      case DashboardTabs.protocols:
        return SvgPicture.asset(
          Images.protocolTabIcon,
          colorFilter:
              const ColorFilter.mode(AppColors.colorB3B3B3, BlendMode.srcIn),
          width: 25,
        );
      case DashboardTabs.profile:
        return user?.primaryImageUrl() == null
            ? SvgPicture.asset(
                Images.userTabIcon,
                colorFilter: const ColorFilter.mode(
                    AppColors.colorB3B3B3, BlendMode.srcIn),
                width: 25,
                height: 25,
                fit: BoxFit.cover,
              )
            : AppImageView(
                avatarUrl: user?.primaryImageUrl(),
                width: 25,
                height: 25,
                placeholderHeight: 25,
                placeholderWidth: 25,
                placeholderImage: Images.userTabIconPng,
              );
    }
  }

  Widget activeIcon(BuildContext context, UserDomain? user) {
    final primaryColor = Theme.of(context).primaryColor;
    switch (this) {
      case DashboardTabs.home:
        return SvgPicture.asset(
          Images.homeTabIcon,
          colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
          width: 25,
        );
      case DashboardTabs.goal:
        return SvgPicture.asset(
          Images.goalTabIcon,
          colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
          width: 25,
        );
      case DashboardTabs.learning:
        return SvgPicture.asset(
          Images.learningTabIcon,
          colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
          width: 25,
        );
      case DashboardTabs.protocols:
        return SvgPicture.asset(
          Images.protocolTabIcon,
          colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
          width: 25,
        );
      case DashboardTabs.profile:
        return user?.primaryImageUrl() == null
            ? SvgPicture.asset(
                Images.userTabIcon,
                colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                width: 25,
                height: 25,
                fit: BoxFit.cover,
              )
            : AppImageView(
                avatarUrl: user?.primaryImageUrl(),
                width: 25,
                height: 25,
                placeholderHeight: 25,
                placeholderWidth: 25,
                placeholderImage: Images.userTabIconPng,
              );
    }
  }

  Widget content() {
    switch (this) {
      case DashboardTabs.home:
        return const HomeScreen();
      case DashboardTabs.profile:
        return const ProfileScreen(
          userId: null,
          isShowingPersonalProfile: true,
        );
      case DashboardTabs.learning:
        return const LearningScreen();
      case DashboardTabs.protocols:
        return const ProtocolTabDashboardScreen();
      case DashboardTabs.goal:
        return const GoalsScreen();
    }
  }
}
