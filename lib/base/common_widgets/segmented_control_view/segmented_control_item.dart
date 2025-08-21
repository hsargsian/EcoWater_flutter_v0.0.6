import 'package:flutter/material.dart';

class SegmentedControlItem {
  SegmentedControlItem(
      {required this.index,
      required this.title,
      Color? selectedBackgroundColor,
      Color? unselectedBackgroundColor,
      Color? selectedTitleColor,
      Color? unselectedTitleColor,
      this.isSelected = false,
      this.showsBottomDivider = false,
      this.onTapped})
      : _selectedBackgroundColor = selectedBackgroundColor,
        _unselectedBackgroundColor = unselectedBackgroundColor,
        _selectedTitleColor = selectedTitleColor,
        _unselectedTitleColor = unselectedTitleColor;
  final int index;
  final String title;
  final Color? _selectedBackgroundColor;
  final Color? _unselectedBackgroundColor;
  final Color? _selectedTitleColor;
  final Color? _unselectedTitleColor;
  final Function? onTapped;
  bool isSelected = false;
  bool showsBottomDivider = false;

  Color get backgroundColor => isSelected
      ? (_selectedBackgroundColor ?? Colors.transparent)
      : (_unselectedBackgroundColor ?? Colors.transparent);
  Color get titleColor => isSelected
      ? (_selectedTitleColor ?? Colors.white)
      : (_unselectedTitleColor ?? Colors.white.withValues(alpha: 0.5));
}
