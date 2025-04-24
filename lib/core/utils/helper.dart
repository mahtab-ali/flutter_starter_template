import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

/// Helper class containing utility methods for common operations
class Helper {
  /// Returns the appropriate directional icon based on text direction (LTR or RTL)
  ///
  /// Parameters:
  /// - [context]: The build context to determine text direction
  /// - [ltrIcon]: The icon to use in left-to-right mode
  /// - [rtlIcon]: The icon to use in right-to-left mode (optional, defaults to flipped ltrIcon)
  static IconData getDirectionalIcon(
    BuildContext context,
    IconData ltrIcon, [
    IconData? rtlIcon,
  ]) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    // If RTL and a specific RTL icon is provided, use it
    if (isRtl && rtlIcon != null) {
      return rtlIcon;
    }

    // Handle common directional icons
    if (isRtl) {
      // Map common LTR icons to their RTL counterparts
      switch (ltrIcon) {
        case LineIcons.angleRight:
          return LineIcons.angleLeft;
        case LineIcons.angleLeft:
          return LineIcons.angleRight;
        case LineIcons.angleDoubleRight:
          return LineIcons.angleDoubleLeft;
        case LineIcons.angleDoubleLeft:
          return LineIcons.angleDoubleRight;
        case LineIcons.arrowRight:
          return LineIcons.arrowLeft;
        case LineIcons.arrowLeft:
          return LineIcons.arrowRight;
        case LineIcons.chevronRight:
          return LineIcons.chevronLeft;
        case LineIcons.chevronLeft:
          return LineIcons.chevronRight;
        case LineIcons.caretRight:
          return LineIcons.caretLeft;
        case LineIcons.caretLeft:
          return LineIcons.caretRight;
        case LineIcons.alternateLongArrowRight:
          return LineIcons.alternateLongArrowLeft;
        case LineIcons.alternateLongArrowLeft:
          return LineIcons.alternateLongArrowRight;
        default:
          return ltrIcon;
      }
    }

    // Default case (LTR)
    return ltrIcon;
  }
}
