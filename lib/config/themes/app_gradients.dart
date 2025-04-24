import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  // Primary gradients - derived from primary colors
  static LinearGradient primaryDiagonal({bool isDark = false}) =>
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isDark ? AppColors.primaryDark : AppColors.primaryLight,
          isDark
              ? Color.lerp(AppColors.primaryDark, Colors.purple, 0.3)!
              : Color.lerp(AppColors.primaryLight, Colors.purple, 0.3)!,
        ],
      );

  static LinearGradient primaryVertical({bool isDark = false}) =>
      LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          isDark ? AppColors.primaryDark : AppColors.primaryLight,
          isDark
              ? AppColors.primaryDark.withAlpha(180)
              : AppColors.primaryLight.withAlpha(180),
        ],
      );

  static LinearGradient primaryHorizontal({bool isDark = false}) =>
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          isDark ? AppColors.primaryDark : AppColors.primaryLight,
          isDark
              ? AppColors.primaryDark.withAlpha(180)
              : AppColors.primaryLight.withAlpha(180),
        ],
      );

  // Accent gradients - derived from accent colors
  static LinearGradient accentDiagonal({bool isDark = false}) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      isDark ? AppColors.accentDark : AppColors.accentLight,
      isDark
          ? AppColors.accentDark.withAlpha(180)
          : AppColors.accentLight.withAlpha(180),
    ],
  );

  static LinearGradient accentVertical({bool isDark = false}) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      isDark ? AppColors.accentDark : AppColors.accentLight,
      isDark
          ? AppColors.accentDark.withAlpha(180)
          : AppColors.accentLight.withAlpha(180),
    ],
  );

  // Variation gradients based on primary colors
  static LinearGradient vibrant({bool isDark = false}) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      isDark ? AppColors.primaryDark : AppColors.primaryLight,
      isDark ? AppColors.accentDark : AppColors.accentLight,
    ],
  );

  // Radial gradient derived from primary
  static RadialGradient radial({bool isDark = false}) => RadialGradient(
    center: Alignment.center,
    radius: 0.8,
    colors: [
      isDark ? AppColors.primaryDark : AppColors.primaryLight,
      isDark
          ? AppColors.primaryDark.withAlpha(75)
          : AppColors.primaryLight.withAlpha(75),
    ],
  );

  // Glass-effect gradients
  static LinearGradient glassLight({
    bool isDark = false,
    double opacity = 0.5,
  }) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white.withAlpha((opacity * 125).round()),
      Colors.white.withAlpha((opacity * 50).round()),
    ],
  );

  static LinearGradient glassDark({
    bool isDark = false,
    double opacity = 0.5,
  }) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.black.withAlpha((opacity * 150).round()),
      Colors.black.withAlpha((opacity * 50).round()),
    ],
  );
}
