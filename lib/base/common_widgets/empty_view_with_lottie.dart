// ignore_for_file: must_be_immutable
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class EmptyViewWithLottie extends StatelessWidget {
  EmptyViewWithLottie(this.lottie, this.message, {super.key});
  String lottie;
  String message;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 250,
      height: 250,
      child: Center(
        child: Column(children: [
          Expanded(
              child: Lottie.asset('assets/lottie/$lottie.json', repeat: true)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primaryElementColor),
          ),
          const SizedBox(
            height: 10,
          )
        ]),
      ),
    ));
  }
}
