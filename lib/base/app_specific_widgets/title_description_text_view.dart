import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleDescriptionTextView extends StatelessWidget {
  const TitleDescriptionTextView(
      {required this.title,
      required this.description,
      this.maxlines,
      super.key});
  final String title;
  final String description;
  final int? maxlines;

  @override
  Widget build(BuildContext context) {
    return description.trim().isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primaryElementColor,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: maxlines ?? 10,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color:
                            Theme.of(context).colorScheme.primaryElementColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              )
            ],
          );
  }
}
