import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/screens/goals_module/add_water_screen/bloc/add_water_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/bottle_and_ppm_view/water_add_view.dart';
import '../../../base/common_widgets/bar/accessory_bar.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/app_styles.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';

class AddWaterConsumptionScreen extends StatefulWidget {
  AddWaterConsumptionScreen({this.onAdditionSuccess, super.key});
  void Function()? onAdditionSuccess;

  @override
  State<AddWaterConsumptionScreen> createState() =>
      _AddWaterConsumptionScreenState();
}

class _AddWaterConsumptionScreenState extends State<AddWaterConsumptionScreen> {
  final GlobalKey<WaterAddViewState> _waterAddViewState = GlobalKey();
  final ValueNotifier<int> waterAmountNotifier = ValueNotifier<int>(0);
  late final AddWaterScreenBloc _bloc;

  @override
  void initState() {
    _bloc = Injector.instance<AddWaterScreenBloc>();
    super.initState();
    _bloc.add(FetchUserInformationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: DecoratedBox(
            decoration: AppStyles.bottomSheetBoxDecoration(context),
            child: BlocConsumer<AddWaterScreenBloc, AddWaterScreenState>(
              bloc: _bloc,
              listener: (context, state) {
                _onStateChanged(state);
              },
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: AccessoryBar(
                            title: 'Add Water'.localized,
                            onCancelPressed: () {
                              Utilities.dismissKeyboard();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: ValueListenableBuilder<int>(
                                        valueListenable: waterAmountNotifier,
                                        builder: (context, waterAmount, child) {
                                          return WaterAddView(
                                            key: _waterAddViewState,
                                            description:
                                                'Manually log any water you drink outside of the flask',
                                            count: waterAmount.toInt(),
                                            onWaterValueUpdated: (value) {
                                              waterAmountNotifier.value =
                                                  int.tryParse(value) ?? 0;
                                            },
                                          );
                                        }),
                                  ),
                                  state is UpdatingProfileState
                                      ? const Center(
                                          child: Loader(),
                                        )
                                      : AppButton(
                                          title: 'Add Water',
                                          onClick: () {
                                            _onDoneButtonPressed();
                                          },
                                          hasGradientBackground: true,
                                        ),
                                ],
                              )),
                        ),
                        _bottomView(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onDoneButtonPressed() {
    Utilities.dismissKeyboard();
    if (waterAmountNotifier.value > 0) {
      _bloc.add(AddWaterConsumptionEvent(waterAmountNotifier.value));
    }
  }

  Widget _bottomView() {
    if (!_bloc.isProfileFetched) {
      return const SizedBox(
        height: 60,
      );
    }
    if (_bloc.hasHealthkitIntegrated) {
      return const SizedBox(
        height: 60,
      );
    }
    return Column(
      children: [
        AppBoxedContainer(
            backgroundColor: Colors.transparent,
            borderSides: const [AppBorderSide.top, AppBorderSide.bottom],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text('AddWaterScreen_integration_message'.localized),
            )),
        SizedBox(
          height: 100,
          child: AppButton(
              title: 'Connect',
              textColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.transparent,
              elevation: 0,
              onClick: () {
                _bloc.add(ProfileEditRequestEvent(true));
              }),
        )
      ],
    );
  }

  void _onStateChanged(AddWaterScreenState state) {
    if (state is ProfileEditApiErrorState) {
      Utilities.showSnackBar(
          context, state.errorMessage, SnackbarStyle.validationError);
    } else if (state is WaterConsumptionAdditionSuccessfulState) {
      widget.onAdditionSuccess?.call();
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
      Navigator.pop(context);
    }
  }
}
