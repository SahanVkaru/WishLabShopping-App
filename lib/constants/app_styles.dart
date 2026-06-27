import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppStyles {
  // ─── Padding & Margins ───
  static const double paddingXS = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;
  static const double paddingXXL = 48.0;

  // ─── Border Radius ───
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 20.0;
  static const double borderRadiusLarge = 32.0;
  static const double borderRadiusXL = 40.0;
  static const BorderRadius cardRadius =
      BorderRadius.all(Radius.circular(borderRadiusMedium));

  // ─── Shadow Presets ───
  static List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 20,
      offset: const Offset(0, 10),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: AppColors.shadowDark.withValues(alpha: 0.12),
      blurRadius: 30,
      offset: const Offset(0, 15),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: AppColors.shadowPrimary,
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  // ─── Input Decoration ───
  static InputDecorationTheme _inputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color focusBorderColor,
    required Color labelColor,
    required Color hintColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: focusBorderColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: TextStyle(color: labelColor, fontSize: 14),
      hintStyle: TextStyle(color: hintColor, fontSize: 14),
      prefixIconColor: labelColor,
      suffixIconColor: labelColor,
    );
  }

  // ─── LIGHT THEME ───
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primarySoft,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryLight,
      surface: AppColors.surfaceLight,
      surfaceContainerHighest: AppColors.surfaceVariantLight,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryLight,
      onError: Colors.white,
      outline: AppColors.dividerLight,
    ),
    textTheme:
        GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: AppColors.textPrimaryLight,
      displayColor: AppColors.textPrimaryLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimaryLight,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: AppColors.shadowPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        padding: const EdgeInsets.symmetric(
            vertical: paddingMedium, horizontal: paddingLarge),
        textStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.button,
        side: const BorderSide(color: AppColors.button, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        padding: const EdgeInsets.symmetric(
            vertical: paddingMedium, horizontal: paddingLarge),
        textStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: cardRadius),
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: _inputDecorationTheme(
      fillColor: AppColors.surfaceVariantLight,
      borderColor: AppColors.dividerLight,
      focusBorderColor: AppColors.primary,
      labelColor: AppColors.textSecondaryLight,
      hintColor: AppColors.textTertiaryLight,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
      elevation: 8,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimaryLight,
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusSmall),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerLight,
      thickness: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.textTertiaryLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primarySoft;
        }
        return AppColors.dividerLight;
      }),
    ),
  );

  // ─── DARK THEME ───
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDarkTheme,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDarkTheme,
      primaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondaryLight,
      secondaryContainer: AppColors.secondary,
      surface: AppColors.surfaceDark,
      surfaceContainerHighest: AppColors.surfaceVariantDark,
      error: AppColors.error,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryDark,
      onError: Colors.white,
      outline: AppColors.dividerDark,
    ),
    textTheme:
        GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: AppColors.textPrimaryDark,
      displayColor: AppColors.textPrimaryDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: AppColors.shadowPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        padding: const EdgeInsets.symmetric(
            vertical: paddingMedium, horizontal: paddingLarge),
        textStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.button,
        side: const BorderSide(color: AppColors.button, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        padding: const EdgeInsets.symmetric(
            vertical: paddingMedium, horizontal: paddingLarge),
        textStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: cardRadius),
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: _inputDecorationTheme(
      fillColor: AppColors.surfaceVariantDark,
      borderColor: AppColors.dividerDark,
      focusBorderColor: AppColors.primaryLight,
      labelColor: AppColors.textSecondaryDark,
      hintColor: AppColors.textTertiaryDark,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
      elevation: 8,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceVariantDark,
      contentTextStyle:
          const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusSmall),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }
        return AppColors.textTertiaryDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryDark;
        }
        return AppColors.dividerDark;
      }),
    ),
  );
}
