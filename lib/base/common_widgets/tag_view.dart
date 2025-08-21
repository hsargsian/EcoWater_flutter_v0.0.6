import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class TagView extends StatelessWidget {
  const TagView({required this.title, this.onTap, super.key});
  final String title;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(50),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(title.localized,
                style: GoogleFonts.quicksand(
                    color: Theme.of(context).primaryColor)),
          ),
        ),
      ),
    );
  }
}
