import 'dart:ui';
import 'package:flutter/material.dart';
import '../../themes/app_gradients.dart';
import '../../themes/universal_constants.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final double blurSigma;
  final LinearGradient? gradient;

  const GlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.blurSigma = 10,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius:
          borderRadius ??
          BorderRadius.circular(UniversalConstants.borderRadiusLarge),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius:
                borderRadius ??
                BorderRadius.circular(UniversalConstants.borderRadiusLarge),
            gradient:
                gradient ??
                (isDark
                    ? AppGradients.glassDark(isDark: isDark)
                    : AppGradients.glassLight(isDark: isDark)),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
