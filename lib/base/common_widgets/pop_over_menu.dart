import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class PopOverMenuEntry extends PopupMenuEntry<int> {
  const PopOverMenuEntry({required this.menuItems, super.key});
  @override
  final height = 200;
  final List<PopOverMenuItem> menuItems;

  @override
  bool represents(value) {
    return true;
  }

  @override
  PopOverMenuEntryState createState() => PopOverMenuEntryState();
}

class PopOverMenuEntryState extends State<PopOverMenuEntry> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(children: widget.menuItems),
      ),
    );
  }
}

class PopOverMenuItem extends StatelessWidget {
  const PopOverMenuItem(
      {required this.title, this.onPressed, this.textColor, super.key});
  final String title;
  final Color? textColor;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(children: [
            Text(
              title.localized,
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  color: textColor ??
                      Theme.of(context).colorScheme.primaryElementColor,
                  fontSize: 15),
            )
          ]),
        ),
      ),
    );
  }
}
