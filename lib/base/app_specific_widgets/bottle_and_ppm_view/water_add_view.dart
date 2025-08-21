import 'package:echowater/base/common_widgets/text_fields/app_textfield.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class WaterAddView extends StatefulWidget {
  const WaterAddView({
    required this.onWaterValueUpdated,
    required this.count,
    this.description,
    super.key,
  });

  final Function(String value) onWaterValueUpdated;
  final int count;
  final String? description;

  @override
  State<WaterAddView> createState() => WaterAddViewState();
}

class WaterAddViewState extends State<WaterAddView> {
  late final TextEditingController _cycleCountController;
  late final FocusNode _cycleCountFocusNode;

  @override
  void initState() {
    super.initState();
    _cycleCountController = TextEditingController();
    _cycleCountFocusNode = FocusNode();
    update(widget.count);
  }

  @override
  void didUpdateWidget(WaterAddView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      update(widget.count);
    }
  }

  void update(int count) {
    _cycleCountController.text = count < 1 ? '' : count.toString();
  }

  @override
  void dispose() {
    _cycleCountController.dispose();
    _cycleCountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'water_selector_view_title'.localized,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (widget.description != null)
          Text(
            widget.description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondaryElementColor,
                ),
          ),
        const SizedBox(height: 50),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(Images.addWaterSVG),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Theme.of(context).colorScheme.primaryElementColor),
              ),
              width: 80,
              height: 60,
              child: AppTextField.textField(
                fontSize: 30,
                verticalPadding: 5,
                fontweight: FontWeight.w800,
                focusNode: _cycleCountFocusNode,
                textAlign: TextAlign.center,
                backgroundColor: Colors.transparent,
                onTextChanged: widget.onWaterValueUpdated,
                context: context,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 3,
                hint: '',
                validator: () => null,
                controller: _cycleCountController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'OZ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
