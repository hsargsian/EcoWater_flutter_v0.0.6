import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_styles.dart';
import '../utils/colors.dart';
import 'text_fields/textfield_header_title_view.dart';

class AppTextView extends StatelessWidget {
  AppTextView(
      {required this.controller,
      required this.placeholder,
      this.maxLength = 1000,
      this.maxLines = 10,
      this.headerTitle,
      this.isRequired = true,
      this.hasError = false,
      this.backgroundColor = AppColors.fieldBackgroundColor,
      this.onChanged,
      super.key});
  final TextEditingController controller;
  final String placeholder;
  int maxLines = 10;
  int maxLength = 1000;
  bool isRequired = true;
  String? headerTitle;
  bool hasError;
  Color? backgroundColor;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldHeaderTitleView(
          title: headerTitle,
          isRequired: isRequired,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: hasError ? AppColors.redColor : backgroundColor,
              border: Border.all(
                color: const Color.fromRGBO(217, 217, 217, 1),
              ),
              borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: 100,
            child: TextField(
                controller: controller,
                style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black),
                maxLines: 10, //or null
                maxLength: 4000,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintMaxLines: 10,
                  isCollapsed: true,
                  counterText: '',
                  fillColor: hasError ? AppColors.redColor : backgroundColor,
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  isDense: true,
                  filled: true,
                  labelText: placeholder,
                  hintStyle: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black.withValues(alpha: 0.7)),
                  labelStyle: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black.withValues(alpha: 0.7)),
                  border: AppStyles.textViewBorder(),
                  enabledBorder: AppStyles.textViewBorder(),
                  focusedBorder: AppStyles.textViewBorder(),
                )),
          ),
        ),
      ],
    );
  }
}
