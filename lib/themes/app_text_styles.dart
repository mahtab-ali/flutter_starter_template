import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Light Theme Text Styles
  static TextStyle headingLargeLight = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle headingMediumLight = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle headingSmallLight = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodyLargeLight = const TextStyle(
    fontSize: 16,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodyMediumLight = const TextStyle(
    fontSize: 14,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodySmallLight = const TextStyle(
    fontSize: 12,
    color: AppColors.textSecondaryLight,
  );

  // Dark Theme Text Styles
  static TextStyle headingLargeDark = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
  );

  static TextStyle headingMediumDark = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
  );

  static TextStyle headingSmallDark = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
  );

  static TextStyle bodyLargeDark = const TextStyle(
    fontSize: 16,
    color: AppColors.textPrimaryDark,
  );

  static TextStyle bodyMediumDark = const TextStyle(
    fontSize: 14,
    color: AppColors.textPrimaryDark,
  );

  static TextStyle bodySmallDark = const TextStyle(
    fontSize: 12,
    color: AppColors.textSecondaryDark,
  );
}
