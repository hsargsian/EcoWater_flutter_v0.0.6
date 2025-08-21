import 'dart:ui';

import 'package:flutter/material.dart';

class SecureOverlay extends StatelessWidget {
  const SecureOverlay({this.switcherWidget, super.key});
  final Widget? switcherWidget;

  @override
  Widget build(BuildContext context) {
    // Use a Container with a blur effect or a solid color obscure the content.
    return Material(
      color: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.shade200.withValues(alpha: 0.5)),
            child: (switcherWidget != null)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [switcherWidget!],
                    ),
                  )
                : const SizedBox.shrink()),
      ),
    );
  }
}
