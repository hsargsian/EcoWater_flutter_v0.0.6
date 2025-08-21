import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

class PPMSliderView extends StatefulWidget {
  const PPMSliderView(
      {required this.onPPMCountUpdated, required this.count, super.key});
  final Function(int value) onPPMCountUpdated;
  final int count;
  @override
  State<PPMSliderView> createState() => PPMSliderViewState();
}

class PPMSliderViewState extends State<PPMSliderView> {
  int _ppmValue = 25;
  final List<double> values = List.generate(50, (index) => 1.0 + index);
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    update(widget.count);
  }

  void update(int ppmValue) {
    _ppmValue = ppmValue;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          '$_ppmValue ${"mg".localized}',
          textAlign: TextAlign.left,
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontFamily: StringConstants.fieldGothicFont),
        ),
        const SizedBox(
          height: 20,
        ),
        Slider(
            thumbColor: Theme.of(context).colorScheme.primaryElementColor,
            max: values.length - 1,
            divisions: values.length - 1,
            value: values.indexOf(_ppmValue.toDouble()).toDouble(),
            onChanged: (index) {
              Utilities.vibrate();
              _ppmValue = values[index.toInt()].toInt();
              setState(() {});
              widget.onPPMCountUpdated.call(_ppmValue);
            })
      ],
    );
  }
}
