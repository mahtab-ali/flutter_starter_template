import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_data.dart';

class AppTextStyles {
  // Method to get text styles for any theme based on locale
  static TextStyle getTextStyle({
    required double fontSize,
    required Color color,
    FontWeight fontWeight = FontWeight.normal,
    Locale? locale,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: AppTheme.getFontFamily(locale),
    );
  }

  // Light Theme Text Styles
  static TextStyle headingLargeLight({Locale? locale}) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    fontFamily: AppTheme.getFontFamily(locale),
  );

  static TextStyle headingMediumLight({Locale? locale}) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    fontFamily: AppTheme.getFontFamily(locale),
  );

  static TextStyle headingSmallLight({Locale? locale}) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    fontFamily: AppTheme.getFontFamily(locale),
  );

  static TextStyle bodyLargeLight({Locale? locale}) => TextStyle(
    fontSize: 16,
    color: AppColors.textPrimaryLight,
    fontFamily: AppTheme.getFontFamily(locale),
  );

  static TextStyle bodyMediumLight({Locale? locale}) => TextStyle(
    fontSize: 14,
    color: AppColors.textPrimaryLight,
    fontFamily: AppTheme.getFontFamily(locale),
  );

  static TextStyle bodySmallLight({Locale? locale}) => TextStyle(
    fontSize: 12,
    color: AppColors.textSecondaryLight,
    fontFamily: AppTheme.getFontFamily(locale),
  );

  // Dark Theme Text Styles
  static TextStyle headingLargeDark({Locale? locale}) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
    fontFamily: AppTheme.getFontFamily(locale),
  );

  static TextStyle headingMediumDark({Locale? locale}) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
    fontFamily: AppTheme.getFontFamily(locale),
  );

  static TextStyle headingSmallDark({Locale? locale}) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
    fontFamily: AppTheme.getFontFamily(locale),
  );

  static TextStyle bodyLargeDark({Locale? locale}) => TextStyle(
    fontSize: 16,
    color: AppColors.textPrimaryDark,
    fontFamily: AppTheme.getFontFamily(locale),
  );

  static TextStyle bodyMediumDark({Locale? locale}) => TextStyle(
    fontSize: 14,
    color: AppColors.textPrimaryDark,
    fontFamily: AppTheme.getFontFamily(locale),
  );

  static TextStyle bodySmallDark({Locale? locale}) => TextStyle(
    fontSize: 12,
    color: AppColors.textSecondaryDark,
    fontFamily: AppTheme.getFontFamily(locale),
  );
}
