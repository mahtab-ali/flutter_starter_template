import 'package:flutter/material.dart';

import '../../themes/universal_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final LinearGradient? gradient;

  const AppCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.gradient,
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
        borderRadius:
            borderRadius ??
            BorderRadius.circular(UniversalConstants.borderRadiusLarge),
        gradient:
            gradient ??
            (isDark
                ? LinearGradient(
                  colors: [Colors.grey[850]!, Colors.grey[900]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : LinearGradient(
                  colors: [Colors.grey[100]!, Colors.grey[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withAlpha(25),
          width: 0.5,
        ),
      ),
      child: child,
    );
  }
}
