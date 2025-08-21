import 'package:flutter/material.dart';

import '../../common_widgets/segmented_control_view/segmented_control_item.dart';
import 'segmented_control_item_view.dart';

@immutable
class SegmentedControlView extends StatefulWidget {
  const SegmentedControlView(
      {required this.items,
      this.mainBackgroundColor,
      this.size = 50.0,
      super.key});
  final List<SegmentedControlItem> items;
  final Color? mainBackgroundColor;
  final double size;

  @override
  State<SegmentedControlView> createState() => _SegmentedControlViewState();
}

class _SegmentedControlViewState extends State<SegmentedControlView> {
  List<SegmentedControlItem> _items = [];
  Color? _mainBackgroundColor;

  @override
  void initState() {
    _items = widget.items;
    _mainBackgroundColor = widget.mainBackgroundColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: _mainBackgroundColor,
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List<Widget>.generate(_items.length, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SegmentedControlItemView(
                    item: _items[index],
                    onTapped: (item) {
                      _onItemSelected(index);
                    },
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }

  void _onItemSelected(int index) {
    _items = _items.map((e) {
      e.isSelected = false;
      return e;
    }).toList();
    _items[index].isSelected = true;
    _items[index].onTapped?.call();
    setState(() {});
  }
}
