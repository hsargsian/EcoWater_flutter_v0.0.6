import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_styles.dart';
import '../../utils/colors.dart';
import 'textfield_header_title_view.dart';

class AppTextField {
  AppTextField._();

  static Widget textField(
      {required BuildContext context,
      required String hint,
      required String? Function() validator,
      required TextEditingController controller,
      Color? backgroundColor = AppColors.fieldBackgroundColor,
      Function(String)? onTextChanged,
      Function(String)? onFieldSubmitted,
      Function()? onTap,
      TextInputType keyboardType = TextInputType.text,
      TextCapitalization textCapitalization = TextCapitalization.sentences,
      Function? onObscureTapped,
      bool isPasswordField = false,
      bool isObsecured = false,
      bool diablesEmojis = true,
      int? maxLines = 1,
      int maxLength = 255,
      double verticalPadding = 15,
      bool isDisabled = false,
      bool isRequired = false,
      List<TextInputFormatter>? inputFormatters,
      String? headerTitle,
      Widget? suffixIcon,
      Widget? prefixIcon,
      FocusNode? focusNode,
      Color? titleColor,
      Color? cursorColor,
      double borderRadius = 10.0,
      Color? textColor,
      bool hasMandatoryBorder = false,
      bool hasError = false,
      double fontSize = 15,
      Iterable<String>? autofillHints,
      FontWeight fontweight = FontWeight.w400,
      Color borderColor = AppColors.transparent,
      TextAlign textAlign = TextAlign.start}) {
    final formatters = <TextInputFormatter>[];
    if (diablesEmojis) {
      formatters.add(FilteringTextInputFormatter.deny(
          RegExp('(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')));
    }
    for (final element in inputFormatters ?? []) {
      formatters.add(element);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldHeaderTitleView(
          isRequired: isRequired,
          title: headerTitle,
          titleColor: titleColor ?? Theme.of(context).colorScheme.primaryElementColor,
        ),
        Opacity(
          opacity: isDisabled ? 0.6 : 1.0,
          child: TextFormField(
            textAlign: textAlign,
            controller: controller,
            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: textColor ?? Theme.of(context).colorScheme.primaryElementColor,
                fontWeight: fontweight,
                fontSize: fontSize),
            validator: (value) => validator.call(),
            onChanged: onTextChanged,
            focusNode: focusNode,
            obscureText: isObsecured,
            keyboardType: keyboardType,
            onFieldSubmitted: onFieldSubmitted,
            textCapitalization: textCapitalization,
            maxLength: maxLength,
            autofillHints: autofillHints,
            onTap: onTap,
            maxLines: maxLines,
            cursorColor: cursorColor,
            readOnly: onTap == null && isDisabled,
            inputFormatters: formatters,
            decoration: InputDecoration(
              counterText: '',
              fillColor: backgroundColor,
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              floatingLabelStyle: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: hasError
                      ? Theme.of(context).colorScheme.appRed
                      : Theme.of(context).colorScheme.primaryElementColor.withValues(alpha: 0.8)),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: (suffixIcon != null || prefixIcon != null) ? 5 : verticalPadding),
              labelText: hint.localized,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor ?? Theme.of(context).colorScheme.primaryElementInvertedeColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
              labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: (textColor ?? Theme.of(context).colorScheme.primaryElementInvertedeColor).withValues(alpha: 0.7),
                  fontWeight: FontWeight.w300,
                  fontSize: 15),
              border: AppStyles.outlinedInputBorder(
                  hasValidationError: hasError,
                  borderRadius: borderRadius,
                  borderColor: borderColor,
                  hasMandatoryBorder: hasMandatoryBorder),
              enabledBorder: AppStyles.outlinedInputBorder(
                  hasValidationError: hasError,
                  borderRadius: borderRadius,
                  borderColor: borderColor,
                  hasMandatoryBorder: hasMandatoryBorder),
              focusedBorder: AppStyles.outlinedInputBorder(
                  hasValidationError: hasError,
                  borderRadius: borderRadius,
                  borderColor: borderColor,
                  hasMandatoryBorder: hasMandatoryBorder),
            ),
          ),
        ),
      ],
    );
  }
}
