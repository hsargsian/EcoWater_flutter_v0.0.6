import 'package:echowater/screens/auth/countdown/bloc/counter_bloc.dart';
import 'package:echowater/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:echowater/screens/flask_module/clean_flask_screen/bloc/clean_flask_screen_bloc.dart';
import 'package:echowater/screens/flask_module/flask_personalization_screen/bloc/flask_personalization_bloc.dart';
import 'package:echowater/screens/flask_module/led_color_selector_screen/bloc/led_color_selector_bloc.dart';
import 'package:echowater/screens/flask_module/my_flasks_listing_screen/bloc/my_flasks_listing_screen_bloc.dart';
import 'package:echowater/screens/flask_module/search_and_pair_screen/bloc/search_and_pair_screen_bloc.dart';
import 'package:echowater/screens/friends/friends_listing_screen/bloc/friends_listing_screen_bloc.dart';
import 'package:echowater/screens/goals_module/add_update_personal_goal_screen/bloc/add_update_personal_goal_screen_bloc.dart';
import 'package:echowater/screens/goals_module/add_update_social_goal_screen/bloc/add_update_scoail_goal_screen_bloc.dart';
import 'package:echowater/screens/goals_module/add_water_screen/bloc/add_water_screen_bloc.dart';
import 'package:echowater/screens/goals_module/goals_screen/bloc/goals_screen_bloc.dart';
import 'package:echowater/screens/home/bloc/home_screen_bloc.dart';
import 'package:echowater/screens/learning_module/learning_screen/bloc/learning_screen_bloc.dart';
import 'package:echowater/screens/profile_module/achievements_screen/bloc/achievements_screen_bloc.dart';
import 'package:echowater/screens/protocols/protocol_tab_dashboard_screen/bloc/protocol_tab_dashboard_screen_bloc.dart';
import 'package:echowater/screens/protocols/sub_views/protocols_listing_view/bloc/protocols_listing_bloc.dart';
import 'package:echowater/screens/settings/integration_settings_screen/bloc/integration_settings_screen_bloc.dart';
import 'package:echowater/screens/settings/settings_screen/bloc/settings_screen_bloc.dart';
import 'package:echowater/screens/settings/tooltip_settings_screen/bloc/tooltip_settings_screen_bloc.dart';

import '../../screens/auth/authentication/bloc/authentication_bloc.dart';
import '../../screens/auth/forgot_password/bloc/forgot_password_bloc.dart';
import '../../screens/auth/login/bloc/login_bloc.dart';
import '../../screens/auth/reset_password/bloc/reset_password_bloc.dart';
import '../../screens/auth/signup/bloc/signup_bloc.dart';
import '../../screens/auth/signup_otp_verify/bloc/signup_otp_verify_bloc.dart';
import '../../screens/device_management/bloc/device_management_bloc.dart';
import '../../screens/friends/add_friends_screen/bloc/add_friends_bloc.dart';
import '../../screens/friends/friend_request_listing_view/bloc/friend_request_listing_view_bloc.dart';
import '../../screens/friends/friends_profile/bloc/friends_profile_bloc.dart';
import '../../screens/goals_module/personal_goal_listing_view/bloc/personal_goal_listing_view_bloc.dart';
import '../../screens/goals_module/social_goal_listing_view/bloc/social_goal_listing_view_bloc.dart';
import '../../screens/learning_module/learning_screen/article_learning_library_listing_view/bloc/article_learning_library_listing_bloc.dart';
import '../../screens/learning_module/learning_screen/video_learning_library_listing_view/bloc/video_learning_library_listing_bloc.dart';
import '../../screens/notifications_screen/bloc/notification_screen_bloc.dart';
import '../../screens/others/help_screen/bloc/help_screen_bloc.dart';
import '../../screens/others/terms_of_service/bloc/terms_of_service_bloc.dart';
import '../../screens/profile_module/change_password/bloc/change_password_bloc.dart';
import '../../screens/profile_module/profile_edit_screen/bloc/profile_edit_bloc.dart';
import '../../screens/profile_module/profile_screen/bloc/profile_screen_bloc.dart';
import '../../screens/protocols/protocol_detail_screen/bloc/protocol_details_screen_bloc.dart';
import '../../screens/protocols/protocol_detail_screen/edit_custom_protocol/bloc/edit_custom_protocol_bloc.dart';
import 'injector.dart';

class BlocModule {
  BlocModule._();

  static void init() {
    final injector = Injector.instance;

    _initializeAuthBloc();
    injector
      ..registerLazySingleton(() => ProfileScreenBloc(
            userRepository: injector(),
            authRepository: injector(),
          ))
      ..registerFactory(() => ChangePasswordBloc(userRepository: injector()))
      ..registerFactory(() => AchievementsScreenBloc(repository: injector()))
      ..registerFactory(() => SettingsScreenBloc(userRepository: injector()))
      ..registerFactory(() => IntegrationSettingsScreenBloc(
          userRepository: injector(), healthService: injector()))
      ..registerFactory(
          () => TooltipSettingsScreenBloc(userRepository: injector()))
      ..registerFactory(() => NotificationScreenBloc(
          notificationRepository: injector(), userRepository: injector()))
      ..registerFactory(() => HelpScreenBloc(otherRepository: injector()))
      ..registerFactory(() => ProfileEditBloc(
            userRepository: injector(),
          ));

    _initializeTertiaryBloc();
    _initializeDashboardBlocs();
    _initializeDevicesBlocs();
    _initializeLearningBlocs();
    _initializeGoalsAndStatsBlocs();
    _initializeFriendsBlocs();
    _initializeProtocolsBlocs();
  }

  static void _initializeProtocolsBlocs() {
    final injector = Injector.instance;
    injector
      ..registerFactory<ProtocolsListingBloc>(() {
        final bloc = ProtocolsListingBloc(protocolRepository: injector());
        return bloc;
      })
      ..registerFactory<ProtocolTabBloc>(() {
        final bloc = ProtocolTabBloc(protocolRepository: injector());
        return bloc;
      })
      ..registerFactory<ProtocolDetailsScreenBloc>(() {
        final bloc = ProtocolDetailsScreenBloc(protocolRepository: injector());
        return bloc;
      })
      ..registerFactory<EditCustomProtocolBloc>(() {
        final bloc = EditCustomProtocolBloc(protocolRepository: injector());
        return bloc;
      });
  }

  static void _initializeGoalsAndStatsBlocs() {
    final injector = Injector.instance;
    injector
      ..registerFactory<GoalsScreenBloc>(() {
        final bloc =
            GoalsScreenBloc(repository: injector(), userRepository: injector());
        return bloc;
      })
      ..registerFactory<AddUpdatePersonalGoalScreenBloc>(() {
        final bloc = AddUpdatePersonalGoalScreenBloc(repository: injector());
        return bloc;
      })
      ..registerFactory<PersonalGoalListingViewBloc>(() {
        final bloc = PersonalGoalListingViewBloc(
            goalsAndStatsRepository: injector(), userRepository: injector());
        return bloc;
      })
      ..registerFactory<SocialGoalListingViewBloc>(() {
        final bloc = SocialGoalListingViewBloc(
            goalsAndStatsRepository: injector(), userRepository: injector());
        return bloc;
      })
      ..registerFactory<AddUpdateSocialGoalScreenBloc>(() {
        final bloc = AddUpdateSocialGoalScreenBloc(repository: injector());
        return bloc;
      })
      ..registerFactory<AddWaterScreenBloc>(() {
        final bloc = AddWaterScreenBloc(
            userRepository: injector(),
            goalAndStatsRepository: injector(),
            healthService: injector());
        return bloc;
      });
  }

  static void _initializeAuthBloc() {
    final injector = Injector.instance;
    injector
      ..registerLazySingleton<AuthenticationBloc>(() => AuthenticationBloc(
          authenticationRepository: injector(),
          userRepository: injector(),
          marketingPushService: injector()))
      ..registerFactory(() => LoginBloc(
          authenticationRepository: injector(),
          userRepository: injector(),
          otherRepository: injector()))
      ..registerFactory(() => SignUpBloc(
          authRepository: injector(),
          userRepository: injector(),
          otherRepository: injector()))
      ..registerFactory(() => SignUpOtpVerifyBloc(authRepository: injector()))
      ..registerFactory(
          () => ForgotPasswordBloc(authenticationRepository: injector()))
      ..registerFactory(CounterBloc.new)
      ..registerFactory(() => ResetPasswordBloc(authRepository: injector()));
  }

  static void _initializeTertiaryBloc() {
    final injector = Injector.instance;
    injector
      ..registerLazySingleton<DeviceManagementBloc>(() {
        final bloc = DeviceManagementBloc(
            deviceRepository: injector(),
            pushNotificationService: injector(),
            deviceInformationRetrievalService: injector());
        return bloc;
      })
      ..registerFactory(() => TermsOfServiceBloc(otherRepository: injector()));
  }

  static void _initializeDashboardBlocs() {
    final injector = Injector.instance;
    injector
      ..registerLazySingleton<DashboardBloc>(() {
        final bloc = DashboardBloc(
            flaskRepository: injector(),
            userRepository: injector(),
            otherRepository: injector());
        return bloc;
      })
      ..registerFactory<HomeScreenBloc>(() {
        final bloc = HomeScreenBloc(
            goalsAndStatsRepository: injector(),
            flaskRepository: injector(),
            userRepository: injector(),
            notificationRepository: injector(),
            marketingPushService: injector());
        return bloc;
      });
  }

  static void _initializeFriendsBlocs() {
    final injector = Injector.instance;
    injector
      ..registerFactory<FriendsListingScreenBloc>(() {
        final bloc = FriendsListingScreenBloc(
            friendRepository: injector(), userRepository: injector());
        return bloc;
      })
      ..registerFactory<FriendRequestsListingViewBloc>(() {
        final bloc = FriendRequestsListingViewBloc(
          friendsRepository: injector(),
        );
        return bloc;
      })
      ..registerFactory<AddFriendsBloc>(() {
        final bloc = AddFriendsBloc(
          friendsRepository: injector(),
          userRepository: injector(),
        );
        return bloc;
      })
      ..registerFactory<FriendsProfileBloc>(() {
        final bloc = FriendsProfileBloc(
            friendRepository: injector(), userRepository: injector());
        return bloc;
      });
  }

  static void _initializeLearningBlocs() {
    final injector = Injector.instance;
    injector
      ..registerFactory<LearningScreenBloc>(() {
        final bloc = LearningScreenBloc(
          repository: injector(),
        );
        return bloc;
      })
      ..registerFactory<VideoLearningLibraryListingBloc>(() {
        final bloc = VideoLearningLibraryListingBloc(
          learningRepository: injector(),
        );
        return bloc;
      })
      ..registerFactory<ArticleLearningLibraryListingBloc>(() {
        final bloc = ArticleLearningLibraryListingBloc(
          learningRepository: injector(),
        );
        return bloc;
      });
  }

  static void _initializeDevicesBlocs() {
    final injector = Injector.instance;
    injector
      ..registerFactory<MyFlasksListingScreenBloc>(() {
        final bloc = MyFlasksListingScreenBloc(
          flaskRepository: injector(),
        );
        return bloc;
      })
      ..registerFactory<SearchAndPairScreenBloc>(() {
        final bloc = SearchAndPairScreenBloc(
          flaskRepository: injector(),
          userRepository: injector(),
        );
        return bloc;
      })
      ..registerFactory<LedColorSelectorBloc>(() {
        final bloc = LedColorSelectorBloc(
          flaskRepository: injector(),
        );
        return bloc;
      })
      ..registerFactory<FlaskPersonalizationBloc>(() {
        final bloc = FlaskPersonalizationBloc(
          flaskRepository: injector(),
          userRepository: injector(),
        );
        return bloc;
      })
      ..registerFactory<CleanFlaskScreenBloc>(() {
        final bloc = CleanFlaskScreenBloc(
          flaskRepository: injector(),
        );
        return bloc;
      });
  }
}
