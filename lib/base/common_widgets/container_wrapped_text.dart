import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class ContainerWrappedText extends StatelessWidget {
  const ContainerWrappedText(
      {required this.title, this.textColor, this.backgroundColor, super.key});
  final Color? textColor;
  final Color? backgroundColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.redColor,
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        title,
        style: GoogleFonts.mulish(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: textColor ?? AppColors.white),
      ),
    );
  }
}
