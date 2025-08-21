import 'dart:async';

import 'package:calendar_view/calendar_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echowater/core/services/firmware_update_log_report_service.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:echowater/oc_libraries/ble_service/flask_manager.dart';
import 'package:echowater/screens/auth/countdown/bloc/counter_bloc.dart';
import 'package:echowater/screens/auth/initial_screen/initial_screen.dart';
import 'package:echowater/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:echowater/screens/dashboard/dashboard_screen.dart';
import 'package:echowater/screens/flask_module/clean_flask_screen/bloc/clean_flask_screen_bloc.dart';
import 'package:echowater/screens/flask_module/led_color_selector_screen/bloc/led_color_selector_bloc.dart';
import 'package:echowater/screens/flask_module/my_flasks_listing_screen/bloc/my_flasks_listing_screen_bloc.dart';
import 'package:echowater/screens/goals_module/add_water_screen/bloc/add_water_screen_bloc.dart';
import 'package:echowater/screens/goals_module/goals_screen/bloc/goals_screen_bloc.dart';
import 'package:echowater/screens/home/bloc/home_screen_bloc.dart';
import 'package:echowater/screens/learning_module/learning_screen/bloc/learning_screen_bloc.dart';
import 'package:echowater/screens/profile_module/achievements_screen/bloc/achievements_screen_bloc.dart';
import 'package:echowater/screens/protocols/protocol_detail_screen/bloc/protocol_details_screen_bloc.dart';
import 'package:echowater/screens/protocols/protocol_detail_screen/edit_custom_protocol/bloc/edit_custom_protocol_bloc.dart';
import 'package:echowater/screens/protocols/protocol_tab_dashboard_screen/bloc/protocol_tab_dashboard_screen_bloc.dart';
import 'package:echowater/screens/settings/integration_settings_screen/bloc/integration_settings_screen_bloc.dart';
import 'package:echowater/screens/settings/tooltip_settings_screen/bloc/tooltip_settings_screen_bloc.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base/common_widgets/no_internet_connection_wrapper.dart';
import 'base/utils/colors.dart';
import 'core/injector/injector.dart';
import 'core/services/api_log_service.dart';
import 'flavor_config.dart';
import 'oc_libraries/app_switcher_protection/app_switcher_protection.dart';
import 'oc_libraries/app_version_checker/app_version_checker_view.dart';
import 'oc_libraries/oc_bug_reporter/oc_bug_reporter_wrapper_screen.dart';
import 'oc_libraries/remote_localization/firebase_localization/firebase_remote_localization_service.dart';
import 'screens/auth/authentication/bloc/authentication_bloc.dart';
import 'screens/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'screens/auth/login/bloc/login_bloc.dart';
import 'screens/auth/reset_password/bloc/reset_password_bloc.dart';
import 'screens/auth/signup/bloc/signup_bloc.dart';
import 'screens/auth/signup_otp_verify/bloc/signup_otp_verify_bloc.dart';
import 'screens/flask_module/flask_personalization_screen/bloc/flask_personalization_bloc.dart';
import 'screens/flask_module/search_and_pair_screen/bloc/search_and_pair_screen_bloc.dart';
import 'screens/friends/friend_request_listing_view/bloc/friend_request_listing_view_bloc.dart';
import 'screens/friends/friends_listing_screen/bloc/friends_listing_screen_bloc.dart';
import 'screens/goals_module/add_update_personal_goal_screen/bloc/add_update_personal_goal_screen_bloc.dart';
import 'screens/goals_module/add_update_social_goal_screen/bloc/add_update_scoail_goal_screen_bloc.dart';
import 'screens/goals_module/personal_goal_listing_view/bloc/personal_goal_listing_view_bloc.dart';
import 'screens/goals_module/social_goal_listing_view/bloc/social_goal_listing_view_bloc.dart';
import 'screens/learning_module/learning_screen/article_learning_library_listing_view/bloc/article_learning_library_listing_bloc.dart';
import 'screens/learning_module/learning_screen/video_learning_library_listing_view/bloc/video_learning_library_listing_bloc.dart';
import 'screens/notifications_screen/bloc/notification_screen_bloc.dart';
import 'screens/others/help_screen/bloc/help_screen_bloc.dart';
import 'screens/others/terms_of_service/bloc/terms_of_service_bloc.dart';
import 'screens/profile_module/change_password/bloc/change_password_bloc.dart';
import 'screens/profile_module/profile_edit_screen/bloc/profile_edit_bloc.dart';
import 'screens/profile_module/profile_screen/bloc/profile_screen_bloc.dart';
import 'screens/protocols/sub_views/protocols_listing_view/bloc/protocols_listing_bloc.dart';
import 'screens/settings/settings_screen/bloc/settings_screen_bloc.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_manager.dart';

class EchoWaterApp extends StatefulWidget {
  const EchoWaterApp({super.key});

  @override
  State<EchoWaterApp> createState() => _EchoWaterAppState();
}

class _EchoWaterAppState extends State<EchoWaterApp> {
  final _navigatorKey = Injector.instance<ApiLogService>().navigationKey;

  NavigatorState? get _navigator => _navigatorKey?.currentState;
  late final AuthenticationBloc _bloc;
  final GlobalKey<AppSwitcherProtectionState> _appSwitcherProtectionViewKey =
      GlobalKey();

  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _bloc = Injector.instance<AuthenticationBloc>();

    super.initState();

    AppThemeManager().onThemeChange = () {
      setState(() {});
    };

    FirebaseRemoteLocalizationService().onLocaleChanged = () {
      setState(() {});
    };
    Injector.instance<FirmwareUpdateLogReportService>()
        .initateOldFirmwareUpgradeCacheUpload();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  void openAppLink(Uri uri) {
    if (kDebugMode) {
      print(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>.value(
          value: _bloc,
        ),
        BlocProvider<LoginBloc>.value(value: Injector.instance<LoginBloc>()),
        BlocProvider<SignUpBloc>.value(value: Injector.instance<SignUpBloc>()),
        BlocProvider<CounterBloc>.value(
            value: Injector.instance<CounterBloc>()),
        BlocProvider<SignUpOtpVerifyBloc>.value(
            value: Injector.instance<SignUpOtpVerifyBloc>()),
        BlocProvider<ForgotPasswordBloc>.value(
            value: Injector.instance<ForgotPasswordBloc>()),
        BlocProvider<ProfileScreenBloc>.value(
            value: Injector.instance<ProfileScreenBloc>()),
        BlocProvider<TermsOfServiceBloc>.value(
            value: Injector.instance<TermsOfServiceBloc>()),
        BlocProvider<NotificationScreenBloc>.value(
            value: Injector.instance<NotificationScreenBloc>()),
        BlocProvider<HelpScreenBloc>.value(
            value: Injector.instance<HelpScreenBloc>()),
        BlocProvider<ProfileEditBloc>.value(
            value: Injector.instance<ProfileEditBloc>()),
        BlocProvider<ChangePasswordBloc>.value(
            value: Injector.instance<ChangePasswordBloc>()),
        BlocProvider<ResetPasswordBloc>.value(
            value: Injector.instance<ResetPasswordBloc>()),
        BlocProvider<DashboardBloc>.value(
            value: Injector.instance<DashboardBloc>()),
        BlocProvider<MyFlasksListingScreenBloc>.value(
            value: Injector.instance<MyFlasksListingScreenBloc>()),
        BlocProvider<LedColorSelectorBloc>.value(
            value: Injector.instance<LedColorSelectorBloc>()),
        BlocProvider<FlaskPersonalizationBloc>.value(
            value: Injector.instance<FlaskPersonalizationBloc>()),
        BlocProvider<LearningScreenBloc>.value(
            value: Injector.instance<LearningScreenBloc>()),
        BlocProvider<GoalsScreenBloc>.value(
            value: Injector.instance<GoalsScreenBloc>()),
        BlocProvider<VideoLearningLibraryListingBloc>.value(
            value: Injector.instance<VideoLearningLibraryListingBloc>()),
        BlocProvider<ArticleLearningLibraryListingBloc>.value(
            value: Injector.instance<ArticleLearningLibraryListingBloc>()),
        BlocProvider<SearchAndPairScreenBloc>.value(
            value: Injector.instance<SearchAndPairScreenBloc>()),
        BlocProvider<AddUpdatePersonalGoalScreenBloc>.value(
            value: Injector.instance<AddUpdatePersonalGoalScreenBloc>()),
        BlocProvider<PersonalGoalListingViewBloc>.value(
            value: Injector.instance<PersonalGoalListingViewBloc>()),
        BlocProvider<CleanFlaskScreenBloc>.value(
            value: Injector.instance<CleanFlaskScreenBloc>()),
        BlocProvider<SettingsScreenBloc>.value(
            value: Injector.instance<SettingsScreenBloc>()),
        BlocProvider<HomeScreenBloc>.value(
            value: Injector.instance<HomeScreenBloc>()),
        BlocProvider<FriendsListingScreenBloc>.value(
            value: Injector.instance<FriendsListingScreenBloc>()),
        BlocProvider<FriendRequestsListingViewBloc>.value(
            value: Injector.instance<FriendRequestsListingViewBloc>()),
        BlocProvider<SocialGoalListingViewBloc>.value(
            value: Injector.instance<SocialGoalListingViewBloc>()),
        BlocProvider<AddUpdateSocialGoalScreenBloc>.value(
            value: Injector.instance<AddUpdateSocialGoalScreenBloc>()),
        BlocProvider<AchievementsScreenBloc>.value(
            value: Injector.instance<AchievementsScreenBloc>()),
        BlocProvider<ProtocolTabBloc>.value(
            value: Injector.instance<ProtocolTabBloc>()),
        BlocProvider<ProtocolDetailsScreenBloc>.value(
            value: Injector.instance<ProtocolDetailsScreenBloc>()),
        BlocProvider<EditCustomProtocolBloc>.value(
            value: Injector.instance<EditCustomProtocolBloc>()),
        BlocProvider<ProtocolsListingBloc>.value(
            value: Injector.instance<ProtocolsListingBloc>()),
        BlocProvider<IntegrationSettingsScreenBloc>.value(
            value: Injector.instance<IntegrationSettingsScreenBloc>()),
        BlocProvider<AddWaterScreenBloc>.value(
            value: Injector.instance<AddWaterScreenBloc>()),
        BlocProvider<TooltipSettingsScreenBloc>.value(
            value: Injector.instance<TooltipSettingsScreenBloc>()),
      ],
      child: CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp(
            theme: EchoWaterTheme(primaryColor: AppColors.primaryLight)
                .getCurrentTheme(context),
            navigatorKey: _navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            builder: (context, child) {
              return PopScope(
                canPop: false,
                child: NoInternetConnectivityWrapper(
                  child: AppSwitcherProtection(
                    key: _appSwitcherProtectionViewKey,
                    usesBiometricAuthentication: false,
                    maxNotMatchCountLimit: 3,
                    switcherWidget: Column(
                      children: [
                        Image.asset(
                          FlavorConfig.appIconImage(),
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ],
                    ),
                    hasAppShield: false,
                    //Constants.hasAppScreenSheild == 1,
                    evictLoggedInUser: () {
                      _terminateLoggedInSubcriptions();
                      Injector.instance<AuthenticationBloc>().add(
                          ExpireUserSessionEvent(
                              resetsDevice: true, deleteAccount: false));
                    },
                    child: OCBugReporterWapperScreen(
                      navigatorKey: _navigatorKey,
                      listId: FlavorConfig.clickUpListId(),
                      apiKey: FlavorConfig.clickUpApiKey(),
                      imageString: FlavorConfig.appIconImage(),
                      isProduction: FlavorConfig.isProduction(),
                      child: AppVersionCheckerView(
                        textColor:
                            Theme.of(context).colorScheme.primaryElementColor,
                        child: BlocListener<AuthenticationBloc,
                            AuthenticationState>(
                          bloc: _bloc,
                          listener: (context, state) {
                            if (state is AuthenticationAuthenticatedState) {
                              BleManager().isUserLoggedIn = true;
                              _navigator?.pushAndRemoveUntil(
                                  DashboardScreen.route(), (route) => false);
                            } else if (state
                                is AuthenticationUnauthenticatedState) {
                              _terminateLoggedInSubcriptions();
                              _navigator?.pushAndRemoveUntil(
                                  InitialScreen.route(), (route) => false);
                            } else if (state is AuthenticationTokenExistState) {
                              BleManager().isUserLoggedIn = true;
                              _navigator?.pushAndRemoveUntil(
                                  DashboardScreen.route(), (route) => false);
                            }
                          },
                          child: child!,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            onGenerateRoute: (settings) {
              return SplashPage.route();
            }),
      ),
    );
  }

  void _terminateLoggedInSubcriptions() {
    BleManager().dispose();
    FlaskManager().dispose();
  }
}
