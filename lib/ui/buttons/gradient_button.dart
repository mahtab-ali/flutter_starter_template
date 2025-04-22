import 'package:flutter/material.dart';
import '../../themes/app_gradients.dart';
import '../../themes/universal_constants.dart';

enum IconPosition { left, right }

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double width;
  final double height;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final IconData? icon;
  final IconPosition iconPosition;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width = double.infinity,
    this.height = 50,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.borderRadius,
    this.gradient,
    this.icon,
    this.iconPosition = IconPosition.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient:
            isDisabled
                ? LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade300],
                )
                : gradient ?? AppGradients.primaryDiagonal(isDark: isDark),
        borderRadius:
            borderRadius ??
            BorderRadius.circular(UniversalConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (isLoading || isDisabled) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ??
                BorderRadius.circular(UniversalConstants.borderRadiusMedium),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    // If there's no icon, just return the text
    if (icon == null) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }

    // Create a row with icon and text in the correct order
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconPosition == IconPosition.left) ...[
          Icon(icon, color: Colors.white),
          const SizedBox(width: UniversalConstants.spacingSmall),
        ],
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (iconPosition == IconPosition.right) ...[
          const SizedBox(width: UniversalConstants.spacingSmall),
          Icon(icon, color: Colors.white),
        ],
      ],
    );
  }
}
