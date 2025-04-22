import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for SystemUiOverlayStyle
import 'app_colors.dart';
import '../config/app_config.dart';
import 'universal_constants.dart';

class AppTheme {
  // Define the font family name constants
  static const String fontFamilyLatin = 'Varela Round';
  static const String fontFamilyArabic = 'Noto Kufi Arabic';

  // Method to get the appropriate font family based on locale
  static String getFontFamily(Locale? locale) {
    // Use Arabic font for Arabic language
    if (locale?.languageCode == 'ar') {
      return fontFamilyArabic;
    }
    // Use Latin font for all other languages
    return fontFamilyLatin;
  }

  static ThemeData lightTheme(Locale? locale) {
    final String fontFamily = getFontFamily(locale);

    return ThemeData(
      useMaterial3: AppConfig.useMaterial3,
      brightness: Brightness.light,
      fontFamily: fontFamily, // Set dynamic font family for entire theme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        onPrimary: Colors.white,
        secondary: AppColors.accentLight,
        onSecondary: Colors.white,
        background: AppColors.backgroundLight,
        surface: AppColors.surfaceLight,
        error: AppColors.errorLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        // Apply font family to app bar title with increased size
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: UniversalConstants.fontSizeXLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLight,
        ),
        // Add systemOverlayStyle to control status bar appearance in light mode
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: AppColors.textPrimaryLight,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimaryLight,
          fontFamily: fontFamily,
        ),
        titleSmall: TextStyle(
          color: AppColors.textPrimaryLight,
          fontFamily: fontFamily,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimaryLight,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textPrimaryLight,
          fontFamily: fontFamily,
        ),
        bodySmall: TextStyle(
          color: AppColors.textSecondaryLight,
          fontFamily: fontFamily,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primaryLight,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontFamily: fontFamily,
          ), // Add dynamic font family to buttons
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.surfaceLight,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryLight),
        ),
        // Add dynamic font family to input fields
        labelStyle: TextStyle(fontFamily: fontFamily),
        hintStyle: TextStyle(fontFamily: fontFamily),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
    );
  }

  static ThemeData darkTheme(Locale? locale) {
    final String fontFamily = getFontFamily(locale);

    return ThemeData(
      useMaterial3: AppConfig.useMaterial3,
      brightness: Brightness.dark,
      fontFamily: fontFamily, // Set dynamic font family for entire theme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        onPrimary: Colors.black,
        secondary: AppColors.accentDark,
        onSecondary: Colors.black,
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        error: AppColors.errorDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        // Apply dynamic font family to app bar title with increased size
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: UniversalConstants.fontSizeXLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
        ),
        // Add systemOverlayStyle to control status bar appearance in dark mode
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: AppColors.textPrimaryDark,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimaryDark,
          fontFamily: fontFamily,
        ),
        titleSmall: TextStyle(
          color: AppColors.textPrimaryDark,
          fontFamily: fontFamily,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimaryDark,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textPrimaryDark,
          fontFamily: fontFamily,
        ),
        bodySmall: TextStyle(
          color: AppColors.textSecondaryDark,
          fontFamily: fontFamily,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primaryDark,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontFamily: fontFamily,
          ), // Add dynamic font family to buttons
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceDark,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.surfaceDark,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryDark),
        ),
        // Add dynamic font family to input fields
        labelStyle: TextStyle(fontFamily: fontFamily),
        hintStyle: TextStyle(fontFamily: fontFamily),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
    );
  }
}
