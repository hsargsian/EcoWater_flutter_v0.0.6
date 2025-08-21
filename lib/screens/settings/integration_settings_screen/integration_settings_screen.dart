import 'dart:io';

import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/common_widgets/image_widgets/app_image_view.dart';
import 'package:echowater/base/utils/colors.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/profile_option.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/screens/settings/integration_settings_screen/bloc/integration_settings_screen_bloc.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/app_bottom_action_sheet_view.dart';
import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/utilities.dart';

class IntegrationSettingsScreen extends StatefulWidget {
  const IntegrationSettingsScreen({super.key});

  @override
  State<IntegrationSettingsScreen> createState() =>
      _IntegrationSettingsScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/IntegrationSettingsScreen'),
        builder: (_) => const IntegrationSettingsScreen());
  }
}

class _IntegrationSettingsScreenState extends State<IntegrationSettingsScreen> {
  late final _bloc = Injector.instance<IntegrationSettingsScreenBloc>();

  bool _isHealthIntegrationEnabled = false;
  @override
  void initState() {
    super.initState();
    _bloc.add(FetchUserInformationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchoWaterNavBar(
          child: NavBar(
              navStyle: NavStyle.singleLined,
              navTitle: ProfileOption.integration.title,
              textColor: Theme.of(context).colorScheme.primaryElementColor,
              leftButton: const LeftArrowBackButton(),
              sideMenuItems: const [])),
      body: BlocConsumer<IntegrationSettingsScreenBloc,
          IntegrationSettingsScreenState>(
        bloc: _bloc,
        listener: (context, state) {
          _onStateChanged(state);
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: AppBoxedContainer(
                    backgroundColor: AppColors.color717171,
                    borderSides: const [
                      AppBorderSide.top,
                      AppBorderSide.bottom
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            'IntegrationScreen_message'.localized,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryElementColor),
                          ),
                        ],
                      ),
                    )),
              ),
              AppBoxedContainer(
                  backgroundColor: AppColors.color717171,
                  borderSides: const [AppBorderSide.top, AppBorderSide.bottom],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Row(
                      children: [
                        AppImageView(
                          placeholderImage: Platform.isIOS
                              ? Images.appleHealthKitIcon
                              : Images.googleFitIcon,
                          width: 50,
                          height: 50,
                          placeholderHeight: 50,
                          placeholderWidth: 50,
                          cornerRadius: 0,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text('Connect with Health Kit',
                                style: Theme.of(context).textTheme.titleSmall)),
                        GestureDetector(
                          onTap: _onButtonTapped,
                          child: Row(
                            children: [
                              _isHealthIntegrationEnabled
                                  ? const Icon(Icons.check_circle_rounded)
                                  : Transform.rotate(
                                      angle: 15, child: const Icon(Icons.link)),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  _isHealthIntegrationEnabled
                                      ? 'Disconnect'
                                      : 'Connect',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }

  void _onButtonTapped() {
    if (_isHealthIntegrationEnabled) {
      Utilities.showBottomSheet(
          widget: AppBottomActionsheetView(
            title: 'IntegrationScreen_disconnect_title'.localized,
            message: 'IntegrationScreen_disconnect_message'.localized,
            posiitiveButtonTitle: 'Confirm'.localized,
            onNegativeButtonClick: () {
              Navigator.pop(context);
            },
            negativeButtonTitle: 'Cancel'.localized,
            onPositiveButtonClick: () {
              Navigator.pop(context);
              _bloc.add(ProfileEditRequestEvent(false));
            },
          ),
          context: context);
    } else {
      _bloc.add(ProfileEditRequestEvent(true));
    }
  }

  void _onStateChanged(IntegrationSettingsScreenState state) {
    if (state is ProfileUpdateCompleteState) {
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
    } else if (state is ProfileEditApiErrorState) {
      Utilities.showSnackBar(
          context, state.errorMessage, SnackbarStyle.validationError);
    } else if (state is ProfileFetchedState) {
      _isHealthIntegrationEnabled =
          state.userProfile.isHealthIntegrationEnabled;

      setState(() {});
    }
  }
}
