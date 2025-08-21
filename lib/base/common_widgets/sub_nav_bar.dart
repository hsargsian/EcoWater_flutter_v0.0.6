import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_specific_widgets/left_arrow_back_button.dart';

class SubNavBar extends StatelessWidget {
  const SubNavBar({required this.title, this.onBackkPressed, super.key});
  final String title;
  final Function()? onBackkPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LeftArrowBackButton(onButtonPressed: () {
          onBackkPressed?.call();
        }),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primaryElementColor),
          ),
        ),
        const SizedBox(
          width: 30,
        )
      ],
    );
  }
}
