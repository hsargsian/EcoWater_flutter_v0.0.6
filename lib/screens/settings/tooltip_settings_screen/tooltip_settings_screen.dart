import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/utils/colors.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/profile_option.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_manager.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/utilities.dart';
import '../../auth/authentication/bloc/authentication_bloc.dart';
import '../../dashboard/dashboard_screen.dart';
import 'bloc/tooltip_settings_screen_bloc.dart';

class TooltipSettingsScreen extends StatefulWidget {
  const TooltipSettingsScreen({super.key});

  @override
  State<TooltipSettingsScreen> createState() => _TooltipSettingsScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/TooltipSettingsScreen'),
        builder: (_) => const TooltipSettingsScreen());
  }
}

class _TooltipSettingsScreenState extends State<TooltipSettingsScreen> {
  late final _bloc = Injector.instance<TooltipSettingsScreenBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.add(FetchTooltipInformationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchoWaterNavBar(
          child: NavBar(
              navStyle: NavStyle.singleLined,
              navTitle: ProfileOption.tooltip.title,
              textColor: Theme.of(context).colorScheme.primaryElementColor,
              leftButton: const LeftArrowBackButton(),
              sideMenuItems: const [])),
      body: BlocConsumer<TooltipSettingsScreenBloc, TooltipSettingsScreenState>(
        bloc: _bloc,
        listener: (context, state) {
          _onStateChanged(state);
        },
        builder: (context, state) {
          return _bloc.isToolTipFetched
              ? Column(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ToolTipScreen_description'.localized,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryElementColor),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Switch(
                                        value: _bloc.isTooltipEnabled,
                                        onChanged: (value) {
                                          _bloc.add(
                                              TooltipEditRequestEvent(value));
                                        }),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                            _bloc.isTooltipEnabled
                                                ? 'On'
                                                : 'Off',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall)),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                )
              : const Center(child: Loader());
        },
      ),
    );
  }

  void _onStateChanged(TooltipSettingsScreenState state) {
    if (state is TooltipInfoUpdatedState) {
      if (state.navigateDashboard) {
        WalkThroughManager().deinit();
        Injector.instance<AuthenticationBloc>()
            .add(AuthenticationCheckUserSessionEvent());
      }
    } else if (state is TooltipApiErrorState) {
      Utilities.showSnackBar(
          context, state.errorMessage, SnackbarStyle.validationError);
    }
  }
}
