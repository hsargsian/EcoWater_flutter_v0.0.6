import 'package:flutter/material.dart';

import '../../../../base/utils/colors.dart';

class TitleCustomDropdownButton extends StatefulWidget {
  const TitleCustomDropdownButton({required this.items, required this.selectTitle, this.selectedRepeat, super.key});

  final List<String> items;
  final String? selectedRepeat;
  final Function(String? value) selectTitle;

  @override
  State<TitleCustomDropdownButton> createState() => _TitleCustomDropdownButtonState();
}

class _TitleCustomDropdownButtonState extends State<TitleCustomDropdownButton> {
  String? _selectedRepeat;

  @override
  void initState() {
    _selectedRepeat = widget.selectedRepeat;
    widget.selectTitle(_selectedRepeat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)), border: Border.all(color: AppColors.accentElementColor)),
      child: DropdownButton<String>(
        underline: const SizedBox.shrink(),
        value: _selectedRepeat,
        hint: const Text('Select Event Name'),
        style: Theme.of(context).textTheme.bodyMedium,
        isDense: true,
        isExpanded: true,
        dropdownColor: AppColors.black,
        items: widget.items.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          _selectedRepeat = newValue!;
          widget.selectTitle(_selectedRepeat);
          setState(() {});
        },
      ),
    );
  }
}
