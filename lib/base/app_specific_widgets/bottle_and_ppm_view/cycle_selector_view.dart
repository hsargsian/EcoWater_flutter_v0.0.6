import 'package:echowater/base/common_widgets/text_fields/app_textfield.dart';
import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CycleSelectorView extends StatefulWidget {
  const CycleSelectorView({required this.onBottleCountUpdated, required this.cycleNumber, required this.count, super.key});

  final Function(String value) onBottleCountUpdated;
  final CycleNumberEnum cycleNumber;
  final int count;

  @override
  State<CycleSelectorView> createState() => CycleSelectorViewState();
}

class CycleSelectorViewState extends State<CycleSelectorView> {
  CycleNumberEnum _bottleType = CycleNumberEnum.one;
  int _count = 1;

  final TextEditingController _cycleCountController = TextEditingController();
  final FocusNode _cycleCountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    update(widget.cycleNumber, widget.count);
  }

  void update(CycleNumberEnum bottleType, int count) {
    _bottleType = bottleType;
    _count = count;
    if (_bottleType == CycleNumberEnum.more) {
      _cycleCountController.text = _count.toString();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'cycle_selector_view_title'.localized,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Center(
            child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(_bottleType.imageString),
            Visibility(
              visible: _bottleType == CycleNumberEnum.more,
              child: SizedBox(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: AppTextField.textField(
                      fontSize: 38,
                      fontweight: FontWeight.w800,
                      focusNode: _cycleCountFocusNode,
                      textAlign: TextAlign.center,
                      backgroundColor: Colors.transparent,
                      onTextChanged: (p0) {
                        widget.onBottleCountUpdated.call(p0);
                      },
                      context: context,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                      ),
                      maxLength: 2,
                      hint: '',
                      validator: () => null,
                      controller: _cycleCountController),
                ),
              ),
            )
          ],
        )),
        const SizedBox(
          height: 12,
        ),
        Column(
          children: [
            Text(_bottleType.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w400, fontFamily: StringConstants.fieldGothicFont)),
            const SizedBox(
              height: 3,
            ),
            Text(_bottleType.description,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.secondaryElementColor)),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: CycleNumberEnum.values.map((item) {
            return Expanded(
              child: InkWell(
                onTap: () {
                  _bottleType = item;
                  setState(() {});
                  if (_bottleType == CycleNumberEnum.more) {
                    _cycleCountFocusNode.requestFocus();
                  } else {
                    widget.onBottleCountUpdated.call(item.key);
                    Utilities.dismissKeyboard();
                  }
                },
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: _bottleType == item ? Theme.of(context).colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: _bottleType == item ? 0 : 1, color: Theme.of(context).colorScheme.primaryElementColor)),
                  child: Center(
                      child: Text(
                    item.key,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w400, fontFamily: StringConstants.fieldGothicTestFont),
                  )),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}

enum CycleNumberEnum {
  one,
  two,
  three,
  more;

  String get title {
    switch (this) {
      case CycleNumberEnum.one:
        return 'cycle_selector_view_one_cycle_numer'.localized;
      case CycleNumberEnum.two:
        return 'cycle_selector_view_two_cycle_numer'.localized;
      case CycleNumberEnum.three:
        return 'cycle_selector_view_three_cycle_numer'.localized;
      case CycleNumberEnum.more:
        return 'cycle_selector_view_more_cycle_numer'.localized;
    }
  }

  String get description {
    switch (this) {
      case CycleNumberEnum.one:
        return 'cycle_selector_view_one_cycle_description'.localized;
      case CycleNumberEnum.two:
        return 'cycle_selector_view_two_cycle_description'.localized;
      case CycleNumberEnum.three:
        return 'cycle_selector_view_three_cycle_description'.localized;
      case CycleNumberEnum.more:
        return 'cycle_selector_view_more_cycle_description'.localized;
    }
  }

  String get imageString {
    switch (this) {
      case CycleNumberEnum.one:
        return Images.oneBottle;
      case CycleNumberEnum.two:
        return Images.twoBottle;
      case CycleNumberEnum.three:
        return Images.threeBottle;
      case CycleNumberEnum.more:
        return Images.moreBottle;
    }
  }

  String get key {
    switch (this) {
      case CycleNumberEnum.one:
        return 'cycle_selector_view_one_cycle_key'.localized;
      case CycleNumberEnum.two:
        return 'cycle_selector_view_two_cycle_key'.localized;
      case CycleNumberEnum.three:
        return 'cycle_selector_view_three_cycle_key'.localized;
      case CycleNumberEnum.more:
        return 'cycle_selector_view_more_cycle_key'.localized;
    }
  }
}
