import 'package:flutter/material.dart';

import '../../../../base/utils/colors.dart';

List<String> repeatList = ['None', 'Every Day', 'Every Active Day', 'Every Rest Day'];

class RepeatCustomDropdownButton extends StatefulWidget {
  const RepeatCustomDropdownButton({required this.selectedRepeat, super.key});

  final Function(String value) selectedRepeat;

  @override
  State<RepeatCustomDropdownButton> createState() => _RepeatCustomDropdownButtonState();
}

class _RepeatCustomDropdownButtonState extends State<RepeatCustomDropdownButton> {
  String _selectedRepeat = 'None';

  @override
  void initState() {
    super.initState();
    widget.selectedRepeat(_selectedRepeat);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Repeat'),
        DropdownButton<String>(
          underline: const SizedBox.shrink(),
          value: _selectedRepeat,
          style: Theme.of(context).textTheme.bodyMedium,
          alignment: Alignment.centerRight,
          dropdownColor: AppColors.black,
          items: repeatList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            _selectedRepeat = newValue!;
            widget.selectedRepeat(_selectedRepeat);
            setState(() {});
          },
        ),
      ],
    );
  }
}
