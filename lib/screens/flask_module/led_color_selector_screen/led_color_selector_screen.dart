import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/common_widgets/navbar/echo_water_nav_bar.dart';
import 'package:echowater/base/common_widgets/navbar/nav_bar.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/core/domain/domain_models/flask_option.dart';
import 'package:echowater/core/domain/domain_models/led_light_color_domain.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:echowater/screens/flask_module/led_color_selector_screen/bloc/led_color_selector_bloc.dart';
import 'package:echowater/screens/flask_module/led_color_selector_screen/led_color_selector_wrapper_view.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/utils/colors.dart';
import '../../../core/injector/injector.dart';

class LedColorSelectorScreen extends StatefulWidget {
  const LedColorSelectorScreen(
      {required this.flask,
      required this.selectedColor,
      this.onColorSelected,
      super.key});
  final LedLightColorDomain selectedColor;
  final Function(LedLightColorDomain)? onColorSelected;
  final FlaskDomain flask;

  @override
  State<LedColorSelectorScreen> createState() => _LedColorSelectorScreenState();

  static Route<void> route(
      {required FlaskDomain flask,
      required LedLightColorDomain selectedColor,
      Function(LedLightColorDomain)? onColorSelected}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/LedColorSelectorScreen'),
        builder: (_) => LedColorSelectorScreen(
              flask: flask,
              selectedColor: selectedColor,
              onColorSelected: onColorSelected,
            ));
  }
}

class _LedColorSelectorScreenState extends State<LedColorSelectorScreen> {
  late LedLightColorDomain _selectedColor;

  late final LedColorSelectorBloc _bloc;

  @override
  void initState() {
    _bloc = Injector.instance<LedColorSelectorBloc>();
    _selectedColor = widget.selectedColor;
    super.initState();
    _bloc.add(FetchAllColorsEvent());
  }

  void _onColorSelected(LedLightColorDomain selectedColor) {
    _selectedColor = selectedColor;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        widget.onColorSelected?.call(_selectedColor);
      },
      child: Scaffold(
        appBar: EchoWaterNavBar(
            child: NavBar(
          navStyle: NavStyle.singleLined,
          leftButton: LeftArrowBackButton(
            onButtonPressed: () {
              Navigator.pop(context);
            },
          ),
          navTitle: 'LCDColorScreen_navTitle'.localized,
          textColor: Theme.of(context).colorScheme.primaryElementColor,
        )),
        body: BlocConsumer<LedColorSelectorBloc, LedColorSelectorState>(
          bloc: _bloc,
          listener: (context, state) {
            _onStateChanged(state, context);
          },
          builder: (context, state) {
            return state is FetchingLedColorsState
                ? const Center(child: Loader())
                : SingleChildScrollView(
                    child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      AppBoxedContainer(
                        borderSides: const [],
                        borderWidth: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text('LCDColorScreen_detailText'.localized),
                        ),
                      ),
                      ..._bloc.ledColors.map((item) {
                        return LedColorSelectorWrapperView(
                          colorWrapper: item,
                          selectedColor: _selectedColor,
                          onItemClick: (p0) {
                            _onColorSelected(p0);
                            final colorValue =
                                HexColor.averageColorFromGradient(p0.colorHexs);
                            final red = colorValue.red;
                            final green = colorValue.green;
                            final blue = colorValue.blue;
                            final commandData =
                                FlaskCommand.colorChange.commandData
                                  ..add(green)
                                  ..add(red)
                                  ..add(blue);
                            BleManager().sendData(
                                widget.flask,
                                FlaskCommand.colorChange,
                                commandData.addingCRC());
                          },
                        );
                      })
                    ],
                  ));
          },
        ),
      ),
    );
  }

  void _onStateChanged(LedColorSelectorState state, BuildContext context) {
    if (state is FetchedLedColorsState) {
      _onColorSelected(widget.selectedColor);
    } else if (state is LedColorSelectorApiErrorState) {}
  }
}
