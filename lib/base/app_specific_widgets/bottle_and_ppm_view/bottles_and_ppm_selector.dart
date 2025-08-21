import 'package:echowater/base/common_widgets/image_widgets/app_image_view.dart';
import 'package:echowater/base/common_widgets/seperator_view.dart';
import 'package:echowater/base/common_widgets/text_fields/app_textfield.dart';
import 'package:echowater/base/constants/constants.dart';
import 'package:echowater/base/utils/colors.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/screens/friends/friends_listing_screen/friends_listing_screen.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/domain/domain_models/add_goal_request_model.dart';
import 'cycle_selector_view.dart';
import 'ppm_slider_view.dart';
import 'water_add_view.dart';

enum BottleOrPPMType {
  ppms,
  water,
  bottle;

  String get title {
    switch (this) {
      case BottleOrPPMType.bottle:
        return 'BottlePPmType_bottle_title'.localized;
      case BottleOrPPMType.ppms:
        return 'BottlePPmType_ppm_title'.localized;
      case BottleOrPPMType.water:
        return 'BottlePPmType_water_title'.localized;
    }
  }

  String get graphHeaderTitle {
    switch (this) {
      case BottleOrPPMType.bottle:
        return 'BottlePPmType_bottle_graph_header_title'.localized;
      case BottleOrPPMType.ppms:
        return 'Daily Hydrogen Consumption'.localized;
      case BottleOrPPMType.water:
        return 'Daily Water Consumption'.localized;
    }
  }

  String get goalTitle {
    switch (this) {
      case BottleOrPPMType.bottle:
        return 'BottlePPmType_bottle_goal_title'.localized;
      case BottleOrPPMType.ppms:
        return 'BottlePPmType_ppm_goal_title'.localized;
      case BottleOrPPMType.water:
        return 'BottlePPmType_water_goal_title'.localized;
    }
  }

  String get segmentedControlTitle {
    switch (this) {
      case BottleOrPPMType.bottle:
        return 'BottlePPmType_bottle_segmented_control_title'.localized;
      case BottleOrPPMType.ppms:
        return 'H2'.localized;
      case BottleOrPPMType.water:
        return 'Water'.localized;
    }
  }

  String get key {
    switch (this) {
      case BottleOrPPMType.bottle:
        return 'bottle_goal';
      case BottleOrPPMType.ppms:
        return 'hydrogen_goal';
      case BottleOrPPMType.water:
        return 'water_goal';
    }
  }

  String get description {
    switch (this) {
      case BottleOrPPMType.bottle:
        return 'BottlePersonalGoal_description'.localized;
      case BottleOrPPMType.ppms:
        return 'hydrogenPersonalGoal_description'.localized;
      case BottleOrPPMType.water:
        return 'WaterPersonalGoal_description'.localized;
    }
  }

  String get deleteActionSheetTitle {
    switch (this) {
      case BottleOrPPMType.bottle:
        return 'BottlePersonalGoal_deleteTitle'.localized;
      case BottleOrPPMType.ppms:
        return 'H2PersonalGoal_deleteTitle'.localized;
      case BottleOrPPMType.water:
        return 'WaterPersonalGoal_deleteTitle'.localized;
    }
  }

  String get deleteActionSheetMessage {
    switch (this) {
      case BottleOrPPMType.bottle:
        return 'BottlePersonalGoal_deleteMessage'.localized;
      case BottleOrPPMType.ppms:
        return 'H2PersonalGoal_deleteMessage'.localized;
      case BottleOrPPMType.water:
        return 'WaterPersonalGoal_deleteMessage'.localized;
    }
  }

  String get icon {
    switch (this) {
      case BottleOrPPMType.bottle:
        return Images.bottleIconSVG;
      case BottleOrPPMType.ppms:
        return Images.hydrogenIconSVG;
      case BottleOrPPMType.water:
        return Images.hydrogenIconSVG;
    }
  }

  int get order {
    switch (this) {
      case BottleOrPPMType.bottle:
        return 0;
      case BottleOrPPMType.ppms:
        return 1;
      case BottleOrPPMType.water:
        return 2;
    }
  }
}

class BottlesPpmWaterSelector extends StatefulWidget {
  const BottlesPpmWaterSelector(
      {required this.isPersonalGoal,
      required this.isEditGoal,
      this.type,
      this.cycleNumber,
      this.total,
      this.socialGoalUser,
      this.goalTitle = '',
      super.key});
  final BottleOrPPMType? type;
  final CycleNumberEnum? cycleNumber;
  final bool isPersonalGoal;
  final bool isEditGoal;
  final int? total;
  final UserDomain? socialGoalUser;
  final String goalTitle;

  @override
  State<BottlesPpmWaterSelector> createState() =>
      BottlesPpmWaterSelectorState();
}

class BottlesPpmWaterSelectorState extends State<BottlesPpmWaterSelector> {
  final GlobalKey<CycleSelectorViewState> _cycleSelectorViewStateKey =
      GlobalKey();
  final GlobalKey<PPMSliderViewState> _ppmSliderViewStateKey = GlobalKey();
  final GlobalKey<WaterAddViewState> _waterAddViewState = GlobalKey();
  BottleOrPPMType _selectedType = BottleOrPPMType.bottle;
  CycleNumberEnum? _selectedCycleNumber = CycleNumberEnum.one;
  final TextEditingController _goalNameTextFieldController =
      TextEditingController();
  int? _total;
  int bottles = 1;
  int waterOunces = 0;
  int ppm = Constants.defaultH2Value;
  UserDomain? _selectedUser;
  String _goalTitle = '';
  bool _isGoalEdit = false;

  AddGoalRequestModel getGoalData() {
    return AddGoalRequestModel(
        _goalNameTextFieldController.text,
        _selectedType,
        _selectedType == BottleOrPPMType.bottle
            ? bottles
            : (_selectedType == BottleOrPPMType.ppms ? ppm : waterOunces),
        _selectedUser,
        widget.isPersonalGoal);
  }

  @override
  void initState() {
    _selectedCycleNumber = widget.cycleNumber ?? CycleNumberEnum.one;
    _selectedType = widget.type ?? BottleOrPPMType.bottle;
    _total = widget.total;
    _selectedUser = widget.socialGoalUser;
    bottles = _total ?? 1;
    waterOunces = _total ?? Constants.defaultWaterOuncesValue;
    _goalTitle = widget.goalTitle;
    ppm = _total ?? Constants.defaultH2Value;
    _isGoalEdit = widget.isEditGoal;
    super.initState();
  }

  void setGoal(
    bool isGoalEdit,
    CycleNumberEnum? cycleNumber,
    int? total,
    UserDomain? selectedUser,
    String? goalTitle,
  ) {
    _selectedCycleNumber = cycleNumber;
    _total = total;
    _selectedUser = selectedUser;
    _goalTitle = goalTitle ?? '';
    _isGoalEdit = isGoalEdit;
    bottles = _total ?? 1;
    waterOunces = _total ?? Constants.defaultWaterOuncesValue;
    ppm = _total ?? Constants.defaultH2Value;
    _cycleSelectorViewStateKey.currentState?.update(
      _selectedCycleNumber ?? CycleNumberEnum.one,
      total ?? 1,
    );
    _ppmSliderViewStateKey.currentState
        ?.update(_total ?? Constants.defaultH2Value);
    _waterAddViewState.currentState
        ?.update(_total ?? Constants.defaultWaterOuncesValue);
    _goalNameTextFieldController.text = _goalTitle;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Opacity(
              opacity: !_isGoalEdit ? 1.0 : 0.3,
              child: Row(
                children: [
                  Expanded(
                    child: BottomOrPPmSelectorView(
                      type: BottleOrPPMType.ppms,
                      isSelected: _selectedType == BottleOrPPMType.ppms,
                      onSelected: () {
                        if (_isGoalEdit) {
                          return;
                        }
                        _selectedType = BottleOrPPMType.ppms;
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: BottomOrPPmSelectorView(
                      type: BottleOrPPMType.water,
                      isSelected: _selectedType == BottleOrPPMType.water,
                      onSelected: () {
                        if (_isGoalEdit) {
                          return;
                        }
                        _selectedType = BottleOrPPMType.water;
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: BottomOrPPmSelectorView(
                      type: BottleOrPPMType.bottle,
                      isSelected: _selectedType == BottleOrPPMType.bottle,
                      onSelected: () {
                        if (_isGoalEdit) {
                          return;
                        }
                        _selectedType = BottleOrPPMType.bottle;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              _selectedType.description,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondaryElementColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SeperatorView(
            height: 0.5,
            seperatorColor: Theme.of(context).colorScheme.secondaryElementColor,
          ),
          _socialGoalItemsView(),
          const SizedBox(
            height: 10,
          ),
          _contentEntryView()
        ],
      ),
    );
  }

  Widget _contentEntryView() {
    switch (_selectedType) {
      case BottleOrPPMType.bottle:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CycleSelectorView(
            key: _cycleSelectorViewStateKey,
            count: _total ?? 1,
            cycleNumber: _selectedCycleNumber ?? CycleNumberEnum.one,
            onBottleCountUpdated: (value) {
              final intValue = int.tryParse(value);
              if (intValue != null) {
                bottles = intValue;
              }
            },
          ),
        );
      case BottleOrPPMType.ppms:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: PPMSliderView(
            key: _ppmSliderViewStateKey,
            count: _total ?? Constants.defaultH2Value,
            onPPMCountUpdated: (value) {
              ppm = value;
            },
          ),
        );
      case BottleOrPPMType.water:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: WaterAddView(
            key: _waterAddViewState,
            count: _total ?? Constants.defaultWaterOuncesValue,
            onWaterValueUpdated: (value) {
              final intValue = int.tryParse(value);
              if (intValue != null) {
                waterOunces = intValue;
              }
            },
          ),
        );
    }
  }

  Widget _socialGoalItemsView() {
    return widget.isPersonalGoal
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: AppTextField.textField(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    borderColor:
                        Theme.of(context).colorScheme.primaryElementColor,
                    context: context,
                    hint: 'bottle_and_ppm_selector_goal_name_placeholder'
                        .localized,
                    validator: () => null,
                    controller: _goalNameTextFieldController),
              ),
              const SizedBox(
                height: 20,
              ),
              SeperatorView(
                height: 0.5,
                seperatorColor:
                    Theme.of(context).colorScheme.secondaryElementColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'bottle_and_ppm_selector_team_member'.localized,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color:
                          Theme.of(context).colorScheme.secondaryElementColor),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _selectedUser == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                                  'bottle_and_ppm_selector_add_a_friend_title'
                                      .localized,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ))),
                          _rightView(
                            'bottle_and_ppm_selector_add_friend_title'
                                .localized,
                            const Icon(Icons.add_circle),
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              AppImageView(
                                width: 40,
                                height: 40,
                                avatarUrl: _selectedUser?.primaryImageUrl(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                      (_selectedUser?.name ?? '')
                                          .capitalizeWords(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                          )))
                            ],
                          )),
                          Visibility(
                            visible: !_isGoalEdit,
                            child: _rightView(
                                'bottle_and_ppm_selector_switch_friend_title'
                                    .localized,
                                SvgPicture.asset(Images.switchUserIcon)),
                          )
                        ],
                      ),
                    ),
              const SizedBox(
                height: 30,
              ),
              SeperatorView(
                height: 0.5,
                seperatorColor:
                    Theme.of(context).colorScheme.secondaryElementColor,
              )
            ],
          );
  }

  Widget _rightView(String title, Widget icon) {
    return InkWell(
      onTap: () {
        Utilities.showBottomSheet(
            widget: FriendsListingScreen(
              showsFriendRequests: false,
              isSelectingFriend: true,
              selectedFriend: _selectedUser,
              onFriendSelected: (p0) {
                _selectedUser = p0;
                setState(() {});
              },
            ),
            context: context);
      },
      child: Row(
        children: [
          Text(title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.secondaryElementColor,
                  )),
          const SizedBox(
            width: 5,
          ),
          icon
        ],
      ),
    );
  }
}

class BottomOrPPmSelectorView extends StatelessWidget {
  const BottomOrPPmSelectorView(
      {required this.type,
      required this.isSelected,
      this.onSelected,
      super.key});
  final BottleOrPPMType type;
  final bool isSelected;
  final Function()? onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: InkWell(
        onTap: () {
          Utilities.dismissKeyboard();
          onSelected?.call();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 2,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.color717171,
              )),
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  type.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryElementColor
                          : Theme.of(context)
                              .colorScheme
                              .secondaryElementColor),
                ),
              )),
              SvgPicture.asset(isSelected
                  ? Images.selectedRadioButton
                  : Images.unselectedRadioButton)
            ],
          ),
        ),
      ),
    );
  }
}
