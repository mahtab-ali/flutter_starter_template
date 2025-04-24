import 'package:flutter/material.dart';
import '../../../../core/constants/universal_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final double elevation;

  const AppCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.gradient,
    this.backgroundColor,
    this.elevation = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width ?? double.infinity, // Default to full width
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? theme.cardColor : Colors.white),
        borderRadius:
            borderRadius ??
            BorderRadius.circular(UniversalConstants.borderRadiusLarge),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withAlpha(20),
            spreadRadius: 1,
            blurRadius: elevation * 2,
            offset: Offset(0, elevation / 2),
          ),
        ],
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withAlpha(25),
          width: 0.5,
        ),
      ),
      child: child,
    );
  }
}
