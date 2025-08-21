import 'package:echowater/base/app_specific_widgets/bottle_and_ppm_view/cycle_selector_view.dart';
import 'package:echowater/base/common_widgets/bar/accessory_bar.dart';
import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/domain/domain_models/personal_goal_domain.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/screens/goals_module/add_update_personal_goal_screen/bloc/add_update_personal_goal_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/bottle_and_ppm_view/bottles_and_ppm_selector.dart';
import '../../../base/common_widgets/buttons/app_button.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';

class AddUpdatePersonalGoalScreen extends StatefulWidget {
  const AddUpdatePersonalGoalScreen(
      {this.type, this.goal, this.onGoalAddedUpdated, super.key});
  final BottleOrPPMType? type;
  final Function()? onGoalAddedUpdated;
  final PersonalGoalDomain? goal;

  @override
  State<AddUpdatePersonalGoalScreen> createState() =>
      _AddUpdatePersonalGoalScreenState();
}

class _AddUpdatePersonalGoalScreenState
    extends State<AddUpdatePersonalGoalScreen> {
  final GlobalKey<BottlesPpmWaterSelectorState> _bottlePPmWaterKey =
      GlobalKey();
  late final AddUpdatePersonalGoalScreenBloc _bloc;

  @override
  void initState() {
    _bloc = Injector.instance<AddUpdatePersonalGoalScreenBloc>();
    _bloc.add(SetPersonalGoalEvent(widget.goal));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
            minHeight: MediaQuery.of(context).size.height * 0.9),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AccessoryBar(
                    title: 'AddUpdatePersonalGoalScreen_personalGoal'.localized,
                    onCancelPressed: () {
                      Utilities.dismissKeyboard();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: BlocConsumer<AddUpdatePersonalGoalScreenBloc,
                          AddUpdatePersonalGoalScreenState>(
                        bloc: _bloc,
                        listener: (context, state) {
                          _onStateChanged(state, context);
                        },
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              BottlesPpmWaterSelector(
                                isEditGoal: widget.goal != null,
                                isPersonalGoal: true,
                                type: widget.type,
                                key: _bottlePPmWaterKey,
                                cycleNumber: _bloc.goal?.cycleNumber() ??
                                    CycleNumberEnum.one,
                                total: _bloc.goal?.total,
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              (state is AddingUpdatingPersonalGoalScreenState)
                                  ? const Center(child: Loader())
                                  : AppButton(
                                      title: widget.goal == null
                                          ? 'Create Goal'
                                          : 'Update Goal',
                                      hasGradientBackground: true,
                                      onClick: () {
                                        _onDoneButtonPressed();
                                      })
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDoneButtonPressed() {
    final data = _bottlePPmWaterKey.currentState?.getGoalData();
    if (data != null) {
      _bloc.add(AddUpdatePersonalGoalEvent(data));
    }
  }

  void _onStateChanged(
      AddUpdatePersonalGoalScreenState state, BuildContext context) {
    if (state is AddedUpdatedPersonalGoalScreenState) {
      widget.onGoalAddedUpdated?.call();
      Navigator.pop(context);
    } else if (state is AddUpdatePersonalGoalScreenApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is GoalSetForEditState) {
      _bottlePPmWaterKey.currentState?.setGoal(_bloc.goal != null,
          _bloc.goal?.cycleNumber(), _bloc.goal?.total, null, '');
    }
  }
}
