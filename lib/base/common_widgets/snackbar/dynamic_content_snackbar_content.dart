import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors.dart';
import '../buttons/image_button.dart';

class DynamicContentSnackBarContent extends StatelessWidget {
  const DynamicContentSnackBarContent(
      {required this.title,
      required this.message,
      required this.icon,
      super.key});
  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageButton(
            height: 20,
            iconScale: 0.5,
            cornerRadius: 5,
            onClick: () {},
            backgroundColor: AppColors.accentElementColor,
            icon: icon,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white),
                ),
                Text(message,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white))
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
              padding: EdgeInsets.zero,
              color: AppColors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              icon: const Icon(Icons.close))
        ],
      ),
    );
  }
}
