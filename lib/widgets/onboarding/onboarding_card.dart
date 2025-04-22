import 'package:flutter/material.dart';
import '../../i18n/app_localizations.dart';
import '../../themes/universal_constants.dart';

class OnboardingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int index;
  final int currentIndex;

  const OnboardingCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = index == currentIndex;
    final isRTL = AppLocalizations.of(context).isRtl;

    // Adjust animation direction based on text direction
    final animationOffset =
        isRTL
            ? (isActive ? const Offset(-50, 0) : Offset.zero)
            : (isActive ? const Offset(0, 50) : Offset.zero);

    return Padding(
      padding: const EdgeInsets.all(UniversalConstants.spacingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon (removed container and background)
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween<double>(begin: isActive ? 0.0 : 1.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.5 + (value * 0.5), // Scale from 50% to 100%
                child: Icon(icon, size: 100, color: theme.colorScheme.primary),
              );
            },
          ),
          const SizedBox(height: UniversalConstants.spacingXXLarge),

          // Title with animation
          TweenAnimationBuilder<Offset>(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            tween: Tween<Offset>(begin: animationOffset, end: Offset.zero),
            builder: (context, offset, child) {
              return Transform.translate(offset: offset, child: child);
            },
            child: Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: UniversalConstants.spacingLarge),

          // Description with animation
          TweenAnimationBuilder<Offset>(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            tween: Tween<Offset>(begin: animationOffset, end: Offset.zero),
            builder: (context, offset, child) {
              return Transform.translate(offset: offset, child: child);
            },
            child: Opacity(
              opacity: 0.7,
              child: Text(
                description,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
