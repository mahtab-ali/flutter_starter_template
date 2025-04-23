import 'package:flutter/material.dart';
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
    final size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: UniversalConstants.spacingLarge,
            vertical: UniversalConstants.spacingMedium,
          ),
          constraints: BoxConstraints(
            maxHeight: size.height * 0.7, // Prevent extreme heights
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Creative animated icon with floating effect
              Container(
                width: size.width * 0.28,
                height: size.width * 0.28,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(15),
                  shape: BoxShape.circle,
                  boxShadow:
                      isActive
                          ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withAlpha(30),
                              blurRadius: 20.0,
                              spreadRadius: 5.0,
                              offset: const Offset(0.0, 0.0),
                            ),
                          ]
                          : [],
                ),
                child: AnimatedContainer(
                  duration: UniversalConstants.animationDurationSlow,
                  curve: Curves.easeOutBack,
                  transform:
                      isActive
                          ? (Matrix4.identity()..translate(0.0, -5.0, 0.0))
                          : Matrix4.identity(),
                  child: Center(
                    child: AnimatedOpacity(
                      opacity: isActive ? 1.0 : 0.6,
                      duration: UniversalConstants.animationDurationMedium,
                      child: Icon(
                        icon,
                        size: size.width * 0.15,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: UniversalConstants.spacingXLarge),

              // Title with animation
              AnimatedOpacity(
                duration: UniversalConstants.animationDurationSlow,
                opacity: isActive ? 1.0 : 0.4,
                child: AnimatedContainer(
                  duration: UniversalConstants.animationDurationSlow,
                  transform:
                      isActive
                          ? Matrix4.identity()
                          : (Matrix4.identity()..translate(0.0, 20.0, 0.0)),
                  child: Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: UniversalConstants.spacingMedium),

              // Description with animation
              AnimatedOpacity(
                duration: UniversalConstants.animationDurationSlow,
                opacity: isActive ? 0.9 : 0.3,
                child: AnimatedContainer(
                  duration: UniversalConstants.animationDurationSlow,
                  transform:
                      isActive
                          ? Matrix4.identity()
                          : (Matrix4.identity()..translate(0.0, 30.0, 0.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UniversalConstants.spacingLarge,
                    ),
                    child: Text(
                      description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurface.withAlpha(200),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
