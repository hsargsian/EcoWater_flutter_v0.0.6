import 'package:flutter/material.dart';

import '../base/utils/app_text_styles.dart';
import '../base/utils/colors.dart';
import 'app_theme_manager.dart';

const defaultFontFamily = 'Nimbus Sans L';

class EchoWaterTheme {
  EchoWaterTheme({required this.primaryColor});

  final Color primaryColor;

  // ignore: long-method
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        fontFamily: defaultFontFamily,
        primaryColor: primaryColor,
        textTheme: getTextTheme(AppColors.primaryElementColorLight),
        primaryColorLight: AppColors.primaryLight,
        primaryColorDark: AppColors.primaryDark,
        dialogBackgroundColor: AppColors.secondaryBackgroundColorLight,
        scaffoldBackgroundColor: AppColors.mainBackgroundColorLight,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        unselectedWidgetColor: AppColors.white,
        iconTheme: IconThemeData(color: primaryColor),
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          secondary: AppColors.mainBackgroundColorLight,
          tertiary: AppColors.secondaryBackgroundColorLight,
          surface: AppColors.gray,
          onPrimary: AppColors.white,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primaryElementColorLight,
          selectionColor: AppColors.primaryElementInvertedColor,
          selectionHandleColor: AppColors.primaryElementInvertedColor,
        ),
        iconButtonTheme: const IconButtonThemeData(style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white))),
        sliderTheme: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.mainBackgroundColorLight,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStatePropertyAll(primaryColor),
          checkColor: const WidgetStatePropertyAll(AppColors.white),
          side: const BorderSide(width: 2, color: AppColors.white),
          shape: const CircleBorder(),
        ),
        tabBarTheme: TabBarThemeData(
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          labelColor: primaryColor,
          unselectedLabelColor: AppColors.black,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          enableFeedback: false,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          unselectedItemColor: AppColors.black,
          backgroundColor: AppColors.mainBackgroundColorLight,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.mainBackgroundColorLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 16),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => primaryColor.withValues(
                alpha: states.contains(WidgetState.disabled) ? 0.3 : 1,
              ),
            ),
            elevation: WidgetStateProperty.all(0),
          ),
        ),
        toggleButtonsTheme: ToggleButtonsThemeData(
          textStyle: const TextStyle(
            fontFamily: defaultFontFamily,
            fontWeight: FontWeight.w500,
          ),
          borderRadius: BorderRadius.circular(10),
          disabledColor: primaryColor,
          selectedColor: AppColors.mainBackgroundColorLight,
          color: primaryColor,
          fillColor: primaryColor,
        ),
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        fontFamily: defaultFontFamily,
        textTheme: getTextTheme(AppColors.primaryElementColorDark),
        primaryColor: primaryColor,
        primaryColorLight: AppColors.primaryLight,
        primaryColorDark: AppColors.primaryDark,
        dialogBackgroundColor: AppColors.secondaryBackgroundColorDark,
        scaffoldBackgroundColor: AppColors.mainBackgroundColorDark,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        unselectedWidgetColor: AppColors.white,
        iconTheme: IconThemeData(color: primaryColor),
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          secondary: AppColors.mainBackgroundColorDark,
          tertiary: AppColors.secondaryBackgroundColorDark,
          surface: AppColors.gray,
          onPrimary: AppColors.white,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primaryElementColorDark,
          selectionColor: AppColors.primaryElementInvertedColor,
          selectionHandleColor: AppColors.primaryElementInvertedColor,
        ),
        sliderTheme: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.mainBackgroundColorDark,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(primaryColor),
          checkColor: WidgetStateProperty.all(AppColors.white),
          side: const BorderSide(width: 2, color: AppColors.white),
          shape: const CircleBorder(),
        ),
        tabBarTheme: TabBarThemeData(
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          labelColor: primaryColor,
          unselectedLabelColor: AppColors.black,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          enableFeedback: false,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          unselectedItemColor: AppColors.black,
          backgroundColor: AppColors.mainBackgroundColorDark,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.mainBackgroundColorDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 16),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => primaryColor.withValues(
                alpha: states.contains(WidgetState.disabled) ? 0.3 : 1,
              ),
            ),
            elevation: WidgetStateProperty.all(0),
          ),
        ),
        toggleButtonsTheme: ToggleButtonsThemeData(
          textStyle: const TextStyle(
            fontFamily: defaultFontFamily,
            fontWeight: FontWeight.w500,
          ),
          borderRadius: BorderRadius.circular(10),
          disabledColor: primaryColor,
          selectedColor: AppColors.mainBackgroundColorDark,
          color: primaryColor,
          fillColor: primaryColor,
        ),
      );

  ThemeData getCurrentTheme(BuildContext context) {
    return darkTheme;
    final platformBrightness = MediaQuery.of(context).platformBrightness;
    if (AppThemeManager().currentAppTheme == AppTheme.defaultTheme) {
      return platformBrightness == Brightness.dark ? darkTheme : lightTheme;
    }
    return AppThemeManager().currentAppTheme == AppTheme.dark ? darkTheme : lightTheme;
  }

  TextTheme getTextTheme(Color color) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: color),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: color),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: color),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: color),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: color),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: color),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: color),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: color),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: color),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: color),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: color),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: color),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: color),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: color),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: color),
    );
  }
}
