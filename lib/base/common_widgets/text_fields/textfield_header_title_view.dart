import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldHeaderTitleView extends StatelessWidget {
  TextFieldHeaderTitleView(
      {this.title, this.isRequired = true, this.titleColor, super.key});

  final String? title;
  bool isRequired = true;
  Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: title != null,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            children: [
              isRequired
                  ? Text(
                      '*',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error),
                    )
                  : Container(),
              Expanded(
                child: Text(
                  (title ?? '').localized,
                  style: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: titleColor ??
                          Theme.of(context).colorScheme.primaryElementColor),
                ),
              ),
            ],
          ),
        ));
  }
}
