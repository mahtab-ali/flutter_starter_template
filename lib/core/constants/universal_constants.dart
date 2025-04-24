import 'package:flutter/material.dart';

/// Universal constants for consistent spacing, padding, and sizing throughout the app.
/// Always use these constants instead of hardcoded values to maintain a consistent UI.
class UniversalConstants {
  // Spacing
  static const double spacingXXSmall = 2.0;
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;

  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;
  static const double borderRadiusCircular = 100.0;
  static const double borderRadiusFull = 100.0; // Added for fully rounded corners

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Font Sizes
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;

  // Common Padding
  static const EdgeInsets paddingSmall = EdgeInsets.all(spacingSmall);
  static const EdgeInsets paddingMedium = EdgeInsets.all(spacingMedium);
  static const EdgeInsets paddingLarge = EdgeInsets.all(spacingLarge);

  // Horizontal Padding
  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(
    horizontal: spacingSmall,
  );
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(
    horizontal: spacingMedium,
  );
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(
    horizontal: spacingLarge,
  );

  // Vertical Padding
  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(
    vertical: spacingSmall,
  );
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(
    vertical: spacingMedium,
  );
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(
    vertical: spacingLarge,
  );

  // Animation Durations
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
}

/// Extension on BuildContext to easily access universal constants
extension UniversalConstantsExtension on BuildContext {
  // Spacing
  double get spacingXXSmall => UniversalConstants.spacingXXSmall;
  double get spacingXSmall => UniversalConstants.spacingXSmall;
  double get spacingSmall => UniversalConstants.spacingSmall;
  double get spacingMedium => UniversalConstants.spacingMedium;
  double get spacingLarge => UniversalConstants.spacingLarge;
  double get spacingXLarge => UniversalConstants.spacingXLarge;
  double get spacingXXLarge => UniversalConstants.spacingXXLarge;

  // Border Radius
  double get borderRadiusSmall => UniversalConstants.borderRadiusSmall;
  double get borderRadiusMedium => UniversalConstants.borderRadiusMedium;
  double get borderRadiusLarge => UniversalConstants.borderRadiusLarge;
  double get borderRadiusXLarge => UniversalConstants.borderRadiusXLarge;
  double get borderRadiusCircular => UniversalConstants.borderRadiusCircular;
  double get borderRadiusFull => UniversalConstants.borderRadiusFull;

  // Padding
  EdgeInsets get paddingSmall => UniversalConstants.paddingSmall;
  EdgeInsets get paddingMedium => UniversalConstants.paddingMedium;
  EdgeInsets get paddingLarge => UniversalConstants.paddingLarge;
  EdgeInsets get paddingHorizontalSmall =>
      UniversalConstants.paddingHorizontalSmall;
  EdgeInsets get paddingHorizontalMedium =>
      UniversalConstants.paddingHorizontalMedium;
  EdgeInsets get paddingHorizontalLarge =>
      UniversalConstants.paddingHorizontalLarge;
  EdgeInsets get paddingVerticalSmall =>
      UniversalConstants.paddingVerticalSmall;
  EdgeInsets get paddingVerticalMedium =>
      UniversalConstants.paddingVerticalMedium;
  EdgeInsets get paddingVerticalLarge =>
      UniversalConstants.paddingVerticalLarge;
}
