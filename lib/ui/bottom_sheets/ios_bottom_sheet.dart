import 'dart:ui';
import 'package:flutter/material.dart';
import '../../themes/universal_constants.dart';

/// Shows an iOS-style bottom sheet with blur effect on background
Future<T?> showIosBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool enableDrag = true,
  double? height,
  bool showDragHandle = true,
  Color? backgroundColor,
  Gradient? backgroundGradient,
  bool applyBackgroundBlur = true,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    // Ensure bottom sheet spans edge-to-edge
    useRootNavigator: true,
    barrierColor: theme.colorScheme.onSurface.withAlpha(70),
    // Remove any internal padding
    useSafeArea: false,
    // Extend under the bottom safe area
    builder: (context) {
      return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: height,
          // Remove all margins to make the sheet extend to screen edges
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            // Keep rounded corners only at the top
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(UniversalConstants.borderRadiusXLarge),
              topRight: Radius.circular(UniversalConstants.borderRadiusXLarge),
            ),
            gradient:
                backgroundGradient ??
                (isDark
                    ? _createDarkerGradient(isDark: true)
                    : _createDarkerGradient(isDark: false)),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                spreadRadius: 2,
                color: theme.colorScheme.onSurface.withAlpha(70),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: height != null ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (showDragHandle)
                Container(
                  margin: const EdgeInsets.only(
                    top: UniversalConstants.spacingSmall,
                  ),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withAlpha(70),
                    borderRadius: BorderRadius.circular(
                      UniversalConstants.spacingXSmall,
                    ),
                  ),
                ),
              Flexible(child: child),
            ],
          ),
        ),
      );
    },
  );
}

/// Creates a gradient with higher opacity for bottom sheets
Gradient _createDarkerGradient({required bool isDark}) {
  if (isDark) {
    // Dark theme gradient with higher opacity
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.grey[900]!.withOpacity(0.95),
        Colors.grey[850]!.withOpacity(0.95),
      ],
    );
  } else {
    // Light theme gradient with higher opacity
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.95),
        Colors.grey[100]!.withOpacity(0.95),
      ],
    );
  }
}

/// A specialized widget to be used inside iOS bottom sheets
/// that creates a visually pleasing layout
class IosBottomSheetContent extends StatelessWidget {
  final String? title;
  final Widget? icon;
  final Widget child;
  final List<Widget>? actions;
  final EdgeInsets contentPadding;

  const IosBottomSheetContent({
    super.key,
    this.title,
    this.icon,
    required this.child,
    this.actions,
    this.contentPadding = const EdgeInsets.all(
      UniversalConstants.spacingMedium,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || icon != null)
          Padding(
            padding: const EdgeInsets.only(
              top: UniversalConstants.spacingMedium,
              left: UniversalConstants.spacingMedium,
              right: UniversalConstants.spacingMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: UniversalConstants.spacingSmall),
                ],
                if (title != null)
                  Text(
                    title!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        Flexible(child: Padding(padding: contentPadding, child: child)),
        if (actions != null && actions!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(UniversalConstants.spacingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:
                  actions!
                      .map(
                        (action) => Padding(
                          padding: const EdgeInsets.only(
                            left: UniversalConstants.spacingSmall,
                          ),
                          child: action,
                        ),
                      )
                      .toList(),
            ),
          ),
      ],
    );
  }
}
