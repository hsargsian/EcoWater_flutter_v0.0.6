import 'package:echowater/base/common_widgets/bar/accessory_bar.dart';
import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/domain/domain_models/social_goal_domain.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/bottle_and_ppm_view/bottles_and_ppm_selector.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import 'bloc/add_update_scoail_goal_screen_bloc.dart';

class AddUpdateSocialGoalScreen extends StatefulWidget {
  const AddUpdateSocialGoalScreen(
      {this.type, this.goal, this.onGoalAddedUpdated, super.key});
  final BottleOrPPMType? type;
  final Function()? onGoalAddedUpdated;
  final SocialGoalDomain? goal;

  @override
  State<AddUpdateSocialGoalScreen> createState() =>
      _AddUpdateSocialGoalScreenState();
}

class _AddUpdateSocialGoalScreenState extends State<AddUpdateSocialGoalScreen> {
  final GlobalKey<BottlesPpmWaterSelectorState> _bottlePPmAndWaterKey =
      GlobalKey();
  late final AddUpdateSocialGoalScreenBloc _bloc;

  @override
  void initState() {
    _bloc = Injector.instance<AddUpdateSocialGoalScreenBloc>();
    _bloc.add(SetSocialGoalEvent(widget.goal));
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
                    title: widget.goal == null
                        ? 'AddUpdateSocialGoalScreen_newSocialGoal'.localized
                        : 'AddUpdateSocialGoalScreen_editSocialGoal'.localized,
                    onCancelPressed: () {
                      Utilities.dismissKeyboard();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: BlocConsumer<AddUpdateSocialGoalScreenBloc,
                        AddUpdateSocialGoalScreenState>(
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
                              isEditGoal: _bloc.goal != null,
                              isPersonalGoal: false,
                              type: widget.type,
                              key: _bottlePPmAndWaterKey,
                              cycleNumber: _bloc.goal?.cycleNumber(),
                              total: _bloc.goal?.total,
                              goalTitle: _bloc.goal?.title ?? '',
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            (state is AddingUpdatingSocialGoalScreenState)
                                ? const Center(child: Loader())
                                : AppButton(
                                    title: widget.goal == null
                                        ? 'Create Goal'
                                        : 'Update Goal',
                                    hasGradientBackground: true,
                                    onClick: () {
                                      _onDoneButtonPressed();
                                    }),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        );
                      },
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
    final data = _bottlePPmAndWaterKey.currentState?.getGoalData();
    if (data != null) {
      _bloc.add(AddUpdateSocialGoalEvent(data));
    }
  }

  void _onStateChanged(
      AddUpdateSocialGoalScreenState state, BuildContext context) {
    if (state is AddedUpdatedSocialGoalScreenState) {
      widget.onGoalAddedUpdated?.call();
      Utilities.dismissKeyboard();
      Navigator.pop(context);
    } else if (state is AddUpdateSocialGoalScreenApiErrorState) {
      Utilities.showSnackBar(
        context,
        state.errorMessage,
        SnackbarStyle.error,
      );
    } else if (state is GoalSetForEditState) {
      _bottlePPmAndWaterKey.currentState?.setGoal(
        _bloc.goal != null,
        _bloc.goal?.cycleNumber(),
        _bloc.goal?.total,
        _bloc.goal?.otherParticipant()?.participantUserDomain,
        _bloc.goal?.title,
      );
    }
  }
}
