import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle
import 'app_colors.dart';
import '../app_config.dart';
import '../../core/constants/universal_constants.dart';

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
      dividerColor: Colors.black.withAlpha(
        20,
      ), // Add divider color with 20% opacity
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        onPrimary: Colors.white,
        secondary: AppColors.accentLight,
        onSecondary: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        error: AppColors.errorLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
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
        // Titles
        titleLarge: TextStyle(
          fontSize: UniversalConstants.fontSizeXXLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLight,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          fontSize: UniversalConstants.fontSizeXLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLight,
          fontFamily: fontFamily,
        ),
        titleSmall: TextStyle(
          fontSize: UniversalConstants.fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLight,
          fontFamily: fontFamily,
        ),
        // Body text
        bodyLarge: TextStyle(
          fontSize: UniversalConstants.fontSizeLarge,
          color: AppColors.textPrimaryLight,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          fontSize: UniversalConstants.fontSizeMedium,
          color: AppColors.textPrimaryLight,
          fontFamily: fontFamily,
        ),
        bodySmall: TextStyle(
          fontSize: UniversalConstants.fontSizeSmall,
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
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.primaryLight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
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
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          color: AppColors.textSecondaryLight,
        ),
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          color: AppColors.textSecondaryLight,
        ),
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
      dividerColor: Colors.white.withAlpha(
        20,
      ), // Add divider color with 20% opacity
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        onPrimary: Colors.black,
        secondary: AppColors.accentDark,
        onSecondary: Colors.black,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        error: AppColors.errorDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
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
        // Titles
        titleLarge: TextStyle(
          fontSize: UniversalConstants.fontSizeXXLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          fontSize: UniversalConstants.fontSizeXLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
          fontFamily: fontFamily,
        ),
        titleSmall: TextStyle(
          fontSize: UniversalConstants.fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
          fontFamily: fontFamily,
        ),
        // Body text
        bodyLarge: TextStyle(
          fontSize: UniversalConstants.fontSizeLarge,
          color: AppColors.textPrimaryDark,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          fontSize: UniversalConstants.fontSizeMedium,
          color: AppColors.textPrimaryDark,
          fontFamily: fontFamily,
        ),
        bodySmall: TextStyle(
          fontSize: UniversalConstants.fontSizeSmall,
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
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: const BorderSide(color: AppColors.primaryDark),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
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
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          color: AppColors.textSecondaryDark,
        ),
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          color: AppColors.textSecondaryDark,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      tooltipTheme: TooltipThemeData(
        textStyle: TextStyle(fontFamily: fontFamily, color: Colors.white),
      ),
    );
  }
}
