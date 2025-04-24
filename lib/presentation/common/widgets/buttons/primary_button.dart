import 'package:flutter/material.dart';
import 'package:starter_template_flutter/core/constants/universal_constants.dart';

/// A primary button with consistent styling.
/// Use this as the main call-to-action button throughout the app.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? minWidth;
  final double? height;
  final IconData? iconData;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.minWidth,
    this.height = 48.0,
    this.iconData,
    this.borderRadius,
    this.backgroundColor,
  });

  /// Creates a text-only version of the primary button (for secondary actions)
  factory PrimaryButton.text({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double? minWidth,
    double? height,
    IconData? iconData,
    BorderRadius? borderRadius,
    Color? backgroundColor,
  }) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      minWidth: minWidth,
      height: height,
      iconData: iconData,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
    );
  }

  /// Creates an outlined version of the primary button (for secondary actions)
  factory PrimaryButton.outlined({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double? minWidth,
    double? height,
    IconData? iconData,
    BorderRadius? borderRadius,
    Color? backgroundColor,
  }) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      minWidth: minWidth,
      height: height,
      iconData: iconData,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor =
        isDisabled
            ? theme.disabledColor.withAlpha(20)
            : backgroundColor ?? theme.primaryColor;

    final textColor =
        isDisabled
            ? theme.disabledColor
            : isDark
            ? Colors.black
            : Colors.white;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: textColor,
      disabledBackgroundColor: bgColor,
      disabledForegroundColor: textColor,
      minimumSize: Size(minWidth ?? 0, height ?? 48.0),
      fixedSize: width != null ? Size(width!, height ?? 48.0) : null,
      shape: RoundedRectangleBorder(
        borderRadius:
            borderRadius ??
            BorderRadius.circular(UniversalConstants.borderRadiusMedium),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconData != null) ...[
          Icon(iconData, size: 18),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    if (isLoading) {
      buttonContent = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
      );
    }

    return ElevatedButton(
      onPressed: isLoading || isDisabled ? null : onPressed,
      style: buttonStyle,
      child: buttonContent,
    );
  }
}

/// The type of button for PrimaryButton
enum ButtonType { filled, outlined, text }
