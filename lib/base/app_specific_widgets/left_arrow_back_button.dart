import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/images.dart';

class LeftArrowBackButton extends StatelessWidget {
  const LeftArrowBackButton({this.onButtonPressed, super.key});
  final Function()? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        Images.arrowBackIcon,
        height: 20,
      ),
      onPressed: () {
        if (onButtonPressed == null) {
          Navigator.pop(context);
          return;
        }
        onButtonPressed?.call();
      },
    );
  }
}
