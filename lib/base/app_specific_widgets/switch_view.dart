import 'package:flutter/material.dart';

class SwitchView extends StatelessWidget {
  const SwitchView(
      {required this.title,
      required this.isOn,
      required this.onChange,
      super.key});
  final String title;
  final bool isOn;
  final Function(bool isOn) onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
            scaleY: 0.9, child: Switch(value: isOn, onChanged: onChange.call)),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ))
      ],
    );
  }
}
