import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

class CreateProtocolView extends StatelessWidget {
  const CreateProtocolView({required this.onClick, super.key});

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(
            'Create Custom Protocol',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
          )),
          IconButton(
              onPressed: onClick,
              icon: Icon(
                Icons.add_circle_outline,
                weight: 0.5,
                color: Theme.of(context).colorScheme.primaryElementColor,
              ))
        ],
      ),
    );
  }
}
