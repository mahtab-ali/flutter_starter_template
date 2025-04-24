import 'package:flutter/material.dart';
import '../../../core/constants/universal_constants.dart';

class AuthHeader extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final double iconSize;

  const AuthHeader({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconSize = 60,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // App Logo with styled icon
        Center(
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor ?? theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: UniversalConstants.spacingXLarge),
      ],
    );
  }
}
