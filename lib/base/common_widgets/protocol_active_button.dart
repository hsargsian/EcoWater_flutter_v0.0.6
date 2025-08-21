import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

class ProtocolActiveButton extends StatelessWidget {
  const ProtocolActiveButton({
    required this.isActive,
    this.onPressed,
    super.key,
  });

  final bool isActive;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isActive,
      child: GestureDetector(
        onTap: () {
          onPressed?.call();
        },
        child: Column(
          children: [
            Icon(
              Icons.star,
              size: 20,
              color: Theme.of(context).colorScheme.primaryElementColor,
            ),
            Text(
              'Active'.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primaryElementColor),
            ),
          ],
        ),
      ),
    );
  }
}
