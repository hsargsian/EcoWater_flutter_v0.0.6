import 'package:flutter/material.dart';

import '../../../base/common_widgets/segmented_control_view/segmented_control_item.dart';

@immutable
class SegmentedControlItemView extends StatelessWidget {
  const SegmentedControlItemView(
      {required this.item, this.onTapped, super.key});
  final SegmentedControlItem item;
  final Function(SegmentedControlItem)? onTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapped?.call(item);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: item.showsBottomDivider
              ? Colors.transparent
              : item.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: item.titleColor,
                      fontWeight:
                          item.isSelected ? FontWeight.w700 : FontWeight.w400),
                ),
              ),
            ),
            Visibility(
              visible: item.showsBottomDivider,
              child: Container(
                height: 2,
                color: item.isSelected
                    ? Theme.of(context).primaryColor
                    : item.backgroundColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
