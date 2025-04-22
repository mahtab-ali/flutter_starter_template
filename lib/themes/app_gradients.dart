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
              ? AppColors.primaryDark.withOpacity(0.7)
              : AppColors.primaryLight.withOpacity(0.7),
        ],
      );

  static LinearGradient primaryHorizontal({bool isDark = false}) =>
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          isDark ? AppColors.primaryDark : AppColors.primaryLight,
          isDark
              ? AppColors.primaryDark.withOpacity(0.7)
              : AppColors.primaryLight.withOpacity(0.7),
        ],
      );

  // Accent gradients - derived from accent colors
  static LinearGradient accentDiagonal({bool isDark = false}) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      isDark ? AppColors.accentDark : AppColors.accentLight,
      isDark
          ? AppColors.accentDark.withOpacity(0.7)
          : AppColors.accentLight.withOpacity(0.7),
    ],
  );

  static LinearGradient accentVertical({bool isDark = false}) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      isDark ? AppColors.accentDark : AppColors.accentLight,
      isDark
          ? AppColors.accentDark.withOpacity(0.7)
          : AppColors.accentLight.withOpacity(0.7),
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
          ? AppColors.primaryDark.withOpacity(0.3)
          : AppColors.primaryLight.withOpacity(0.3),
    ],
  );

  // Glass-effect gradients
  static LinearGradient glassLight({bool isDark = false}) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.2)],
  );

  static LinearGradient glassDark({bool isDark = false}) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.1)],
  );
}
