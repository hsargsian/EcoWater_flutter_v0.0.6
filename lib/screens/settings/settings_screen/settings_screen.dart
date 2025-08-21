import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/app_specific_widgets/switch_view.dart';
import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/utils/colors.dart';
import 'package:echowater/base/utils/pair.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/settings_type.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/screens/settings/settings_screen/bloc/settings_screen_bloc.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/utilities.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.settingsType, super.key});
  final SettingsType settingsType;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

  static Route<void> route({required SettingsType settingsType}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/SettingsScreen'),
        builder: (_) => SettingsScreen(
              settingsType: settingsType,
            ));
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final _bloc = Injector.instance<SettingsScreenBloc>();

  @override
  void initState() {
    _bloc.add(SetSettingsTypeEvent(widget.settingsType));
    super.initState();
    _bloc.add(FetchSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchoWaterNavBar(
          child: NavBar(
              navStyle: NavStyle.singleLined,
              navTitle: widget.settingsType.navTitle,
              textColor: Theme.of(context).colorScheme.primaryElementColor,
              leftButton: const LeftArrowBackButton(),
              sideMenuItems: const [])),
      body: BlocConsumer<SettingsScreenBloc, SettingsScreenState>(
        bloc: _bloc,
        listener: (context, state) {
          _onStateChanged(state, context);
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
                            widget.settingsType.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryElementColor),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SwitchView(
                              title: 'settings_screen_all'.localized,
                              isOn: _bloc.settingsTypes
                                      .map((item) => item.second)
                                      .where((item) => item)
                                      .toList()
                                      .length ==
                                  _bloc.settingsTypes.length,
                              onChange: (flag) {
                                _bloc.add(UpdateSettingsEvent(
                                    notificationSettings:
                                        _bloc.settingsTypes.map((item) {
                                  item.second = flag;
                                  return item;
                                }).toList()));
                              }),
                          if (state is FetchingSettingsState)
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Center(child: Loader()),
                            )
                        ],
                      ),
                    )),
              ),
              if (state is! FetchingSettingsState)
                AppBoxedContainer(
                    backgroundColor: AppColors.color717171,
                    borderSides: const [AppBorderSide.bottom],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        children: _bloc.settingsTypes.map((item) {
                          return SwitchView(
                              title: item.first.title,
                              isOn: item.second,
                              onChange: (value) {
                                _bloc.add(UpdateSettingsEvent(
                                    notificationSettings: [
                                      Pair(first: item.first, second: value)
                                    ]));
                              });
                        }).toList(),
                      ),
                    )),
            ],
          );
        },
      ),
    );
  }

  void _onStateChanged(SettingsScreenState state, BuildContext context) {
    if (state is SettingsScreenApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is UpdatedSettingsState) {
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
    }
  }
}
