import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/app_specific_widgets/led_color_view.dart';
import 'package:echowater/core/domain/domain_models/led_light_color_domain.dart';
import 'package:echowater/core/domain/domain_models/led_light_color_wrapper_domain.dart';
import 'package:flutter/material.dart';

class LedColorSelectorWrapperView extends StatelessWidget {
  const LedColorSelectorWrapperView(
      {required this.colorWrapper,
      required this.selectedColor,
      this.onItemClick,
      super.key});
  final LedLightColorWrapperDomain colorWrapper;
  final LedLightColorDomain selectedColor;
  final Function(LedLightColorDomain)? onItemClick;

  @override
  Widget build(BuildContext context) {
    return colorWrapper.colors.isEmpty
        ? const SizedBox.shrink()
        : AppBoxedContainer(
            borderSides: const [AppBorderSide.bottom],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(colorWrapper.title),
                  const SizedBox(
                    height: 20,
                  ),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        colorWrapper.items.length, // Example number of items
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 5,
                            crossAxisCount: 4,
                            crossAxisSpacing: 4,
                            childAspectRatio: 0.85),
                    itemBuilder: (context, index) {
                      return LedColorView(
                        color: colorWrapper.items[index],
                        selectedColor: selectedColor,
                        isLabelShown: true,
                        onSelected: (p0) {
                          onItemClick?.call(p0);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
