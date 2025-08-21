import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/profile_option.dart';
import 'package:echowater/core/domain/domain_models/settings_type.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_wrapper.dart';
import 'package:echowater/screens/flask_module/flask_personalization_screen/flask_upgrade_screen.dart';
import 'package:echowater/screens/flask_module/my_flasks_listing_screen/my_flasks_listing_screen.dart';
import 'package:echowater/screens/notifications_screen/notifications_screen.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_app_intro_screen.dart';
import 'package:echowater/screens/profile_module/ble_configurator_screen/ble_configurator_screen.dart';
import 'package:echowater/screens/profile_module/change_password/change_password_screen.dart';
import 'package:echowater/screens/profile_module/profile_screen/sub_views/profile_options_view.dart';
import 'package:echowater/screens/settings/integration_settings_screen/integration_settings_screen.dart';
import 'package:echowater/screens/settings/settings_screen/settings_screen.dart';
import 'package:echowater/screens/settings/tooltip_settings_screen/tooltip_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/common_widgets/alert/alert.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';
import '../../../core/services/walkthrough_manager/walk_through_info_view.dart';
import '../../../core/services/walkthrough_manager/walk_through_item.dart';
import '../../../core/services/walkthrough_manager/walk_through_manager.dart';
import '../../../core/services/walkthrough_manager/walk_through_screen_item.dart';
import '../../auth/authentication/bloc/authentication_bloc.dart';
import '../../dashboard/sub_views/tab_contents.dart';
import '../profile_edit_screen/profile_edit_screen.dart';
import 'bloc/profile_screen_bloc.dart';
import 'sub_views/profile_header_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {required this.userId,
      required this.isShowingPersonalProfile,
      super.key});

  final bool isShowingPersonalProfile;
  final String? userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

  static Route<void> route(
      {required String userId, required bool isShowingPersonalProfile}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/ProfileScreen'),
        builder: (_) => ProfileScreen(
              userId: userId,
              isShowingPersonalProfile: isShowingPersonalProfile,
            ));
  }
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final ProfileScreenBloc _profileScreenBloc;

  @override
  void initState() {
    _profileScreenBloc = Injector.instance<ProfileScreenBloc>();
    super.initState();
    _fetchInformations();

    _setUpWalkthrough();
  }

  void _setUpWalkthrough() {
    WalkThroughManager().reloadScreen = () {
      if (mounted) {
        setState(() {});
      }

      if (WalkThroughManager().currentWalkthroughItem == WalkThroughItem.none) {
        _fetchInformations();
        if (WalkThroughManager().currentWalkthroughItem ==
            WalkThroughItem.none) {
          WalkThroughManager().switchTabScreen?.call(DashboardTabs.home);
        }
      }
    };
    Future.delayed(const Duration(seconds: 2), () {
      if (WalkThroughManager().currentTab != DashboardTabs.profile) {
        return;
      }
      WalkThroughManager().setProfileScreenWalkThrough();
    });
  }

  void _fetchInformations() {
    _profileScreenBloc.add(FetchUserInformationEvent(
      widget.isShowingPersonalProfile,
      widget.userId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchoWaterNavBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Container(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: BlocConsumer<ProfileScreenBloc, ProfileScreenState>(
                bloc: _profileScreenBloc,
                listener: (context, state) {
                  _onStateChanged(state);
                },
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileHeaderView(
                        user: _profileScreenBloc.profileInformation,
                        canEditProfile: widget.isShowingPersonalProfile,
                        onEditClick: () {
                          Navigator.push(context, ProfileEditScreen.route(
                            didUpdateProfile: () {
                              _profileScreenBloc.add(FetchUserInformationEvent(
                                widget.isShowingPersonalProfile,
                                widget.userId,
                              ));
                            },
                          ));
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ColoredBox(
                        color: Theme.of(context).colorScheme.tertiary,
                        child: WalkThroughWrapper(
                          clipRadius: 20,
                          hasWalkThough:
                              WalkThroughManager().currentWalkthroughItem ==
                                  WalkThroughItem.profileSettingsOptions,
                          child: ProfileOptionsView(
                            onItemClick: (p0) {
                              switch (p0) {
                                case ProfileOption.devices:
                                  Navigator.push(
                                      context, MyDevicesListingScreen.route());
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             FlaskUpgradeScreen()));
                                case ProfileOption.notifications:
                                  Navigator.push(
                                      context, NotificationsScreen.route());
                                case ProfileOption.notificationSettings:
                                  Navigator.push(
                                      context,
                                      SettingsScreen.route(
                                          settingsType:
                                              SettingsType.pushNotification));
                                case ProfileOption.emailSettings:
                                  Navigator.push(
                                      context,
                                      SettingsScreen.route(
                                          settingsType:
                                              SettingsType.emailNotification));
                                case ProfileOption.integration:
                                  Navigator.push(context,
                                      IntegrationSettingsScreen.route());
                                case ProfileOption.tooltip:
                                  Navigator.push(
                                      context, TooltipSettingsScreen.route());
                                case ProfileOption.changePassword:
                                  Navigator.push(
                                      context, ChangePassworScreen.route());
                                case ProfileOption.deleteAccount:
                                  _showDeleteAccountAlert();
                                case ProfileOption.logout:
                                  _showLogoutAlert();
                                case ProfileOption.onboarding:
                                  Navigator.push(
                                      context,
                                      OnboardingAppIntroScreen.route(
                                          isFromProfile: true));
                                case ProfileOption.bleUUIds:
                                  Navigator.push(
                                      context, BleConfiguratorScreen.route());
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  );
                }),
          ),
          Visibility(
              visible: WalkThroughManager().isShowingWalkThrough,
              child: Positioned.fill(
                  child: Container(
                color: AppColors.walkthroughBarrierColor,
              ))),
          Visibility(
            visible: WalkThroughManager().currentWalkthroughItem !=
                WalkThroughItem.none,
            //// we can not make const
            // ignore: prefer_const_constructors
            child: Positioned(
                bottom: WalkThroughManager().currentWalkthroughItem ==
                        WalkThroughItem.profileEditProfile
                    ? 10
                    : null,
                top: WalkThroughManager().currentWalkthroughItem ==
                        WalkThroughItem.profileEditProfile
                    ? null
                    : 10,
                left: 10,
                right: 10,
                // ignore: prefer_const_constructors
                child: WalkThroughInfoView(
                  screenItem: WalkThroughScreenItem.profile,
                )),
          )
        ],
      ),
    );
  }

  void _onStateChanged(ProfileScreenState state) {
    if (state is ProfileScreenApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is ProfileFetchedState) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _showDeleteAccountAlert() {
    final alert = Alert();
    alert.showAlert(
        context: context,
        title: 'ProfileScreen_DeleteAccount'.localized,
        isWarningAlert: true,
        message: 'ProfileScreen_DeleteAccountMessage'.localized,
        actionWidget: alert.getDefaultTwoButtons(
            firstButtonTitle:
                'ProfileScreen_DeleteAccountMessageNotNow'.localized,
            lastButtonTitle: 'ProfileScreen_DeleteAccountMessageYes'.localized,
            onFirstButtonClick: () {
              Navigator.pop(context);
            },
            onLastButtonClick: () {
              Navigator.pop(context);
              Injector.instance<AuthenticationBloc>().add(
                  ExpireUserSessionEvent(
                      resetsDevice: true, deleteAccount: true));
            },
            context: context,
            isAlternate: true));
  }

  void _showLogoutAlert() {
    final alert = Alert();
    alert.showAlert(
        context: context,
        title: 'ProfileScreen_Logout'.localized,
        message: 'ProfileScreen_LogoutMessage'.localized,
        actionWidget: alert.getDefaultTwoButtons(
            firstButtonTitle: 'ProfileScreen_LogoutNotNow'.localized,
            lastButtonTitle: 'ProfileScreen_LogoutYesLogout'.localized,
            onFirstButtonClick: () {
              Navigator.pop(context);
            },
            onLastButtonClick: () {
              Navigator.pop(context);
              _profileScreenBloc.add(LogoutUserRequestEvent());
              // Injector.instance<AuthenticationBloc>().add(
              //     ExpireUserSessionEvent(
              //         resetsDevice: true, deleteAccount: false));
            },
            context: context,
            isAlternate: true));
  }
}
