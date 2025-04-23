import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/universal_constants.dart';

enum ButtonType { primary, outline, text }

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double height;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double minWidth;
  final ButtonType buttonType;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height = 50,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.minWidth = 120,
    this.buttonType = ButtonType.primary,
  });

  factory PrimaryButton.outline({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double height = 50,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16),
    BorderRadius? borderRadius,
    Color? borderColor,
    Color? textColor,
    double minWidth = 120,
  }) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      height: height,
      padding: padding,
      borderRadius: borderRadius,
      borderColor: borderColor,
      textColor: textColor,
      minWidth: minWidth,
      buttonType: ButtonType.outline,
    );
  }

  factory PrimaryButton.text({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double height = 50,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16),
    BorderRadius? borderRadius,
    Color? textColor,
    double minWidth = 120,
  }) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      height: height,
      padding: padding,
      borderRadius: borderRadius,
      textColor: textColor,
      minWidth: minWidth,
      buttonType: ButtonType.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor =
        isDark ? AppColors.primaryDark : AppColors.primaryLight;
    final defaultTextColor =
        buttonType == ButtonType.primary ? Colors.white : primaryColor;

    // Button style based on type
    ButtonStyle getButtonStyle() {
      switch (buttonType) {
        case ButtonType.primary:
          return ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? primaryColor,
            foregroundColor: textColor ?? defaultTextColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius:
                  borderRadius ??
                  BorderRadius.circular(UniversalConstants.borderRadiusMedium),
            ),
            elevation: 2,
          );
        case ButtonType.outline:
          return OutlinedButton.styleFrom(
            foregroundColor: textColor ?? primaryColor,
            padding: padding,
            side: BorderSide(color: borderColor ?? primaryColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius:
                  borderRadius ??
                  BorderRadius.circular(UniversalConstants.borderRadiusMedium),
            ),
          );
        case ButtonType.text:
          return TextButton.styleFrom(
            foregroundColor: textColor ?? primaryColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius:
                  borderRadius ??
                  BorderRadius.circular(UniversalConstants.borderRadiusMedium),
            ),
          );
      }
    }

    // Create the appropriate button widget based on type
    Widget button;
    switch (buttonType) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: getButtonStyle(),
          child: _getButtonContent(),
        );
        break;
      case ButtonType.outline:
        button = OutlinedButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: getButtonStyle(),
          child: _getButtonContent(),
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: getButtonStyle(),
          child: _getButtonContent(),
        );
        break;
    }

    return SizedBox(
      width: width,
      height: height,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: button,
      ),
    );
  }

  Widget _getButtonContent() {
    return isLoading
        ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
        : Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        );
  }
}
