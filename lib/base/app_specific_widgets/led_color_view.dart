import 'package:echowater/core/domain/domain_models/led_light_color_domain.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class LedColorView extends StatelessWidget {
  const LedColorView(
      {required this.color,
      required this.isLabelShown,
      required this.selectedColor,
      this.onSelected,
      bool showsSelectionIcon = true,
      super.key})
      : _showsSelectionIcon = showsSelectionIcon;
  final LedLightColorDomain color;
  final Function(LedLightColorDomain)? onSelected;
  final bool isLabelShown;
  final LedLightColorDomain selectedColor;
  final bool _showsSelectionIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelected?.call(color);
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: color.isGradientColor
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            colors:
                                color.colorHexs.map(HexColor.fromHex).toList()))
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor.fromHex(color.colorHexs.first)),
              ),
              Visibility(
                visible: color == selectedColor && _showsSelectionIcon,
                child: Positioned.fill(
                    child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Icon(
                      size: 30,
                      Icons.check,
                      color: AppColors.white,
                    ),
                  ),
                )),
              )
            ],
          ),
          Visibility(
            visible: isLabelShown,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                color.title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
