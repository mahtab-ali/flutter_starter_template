import 'dart:ui';
import 'package:flutter/material.dart';
import '../../themes/app_gradients.dart';
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
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: applyBackgroundBlur ? 5.0 : 0.0,
          sigmaY: applyBackgroundBlur ? 5.0 : 0.0,
        ),
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: height,
            margin: const EdgeInsets.fromLTRB(
              UniversalConstants.spacingMedium,
              0,
              UniversalConstants.spacingMedium,
              UniversalConstants.spacingMedium,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                UniversalConstants.borderRadiusLarge,
              ),
              gradient:
                  backgroundGradient ??
                  (isDark
                      ? AppGradients.glassDark(isDark: isDark)
                      : AppGradients.glassLight(isDark: isDark)),
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1)),
              ],
            ),
            child: Column(
              mainAxisSize:
                  height != null ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (showDragHandle)
                  Container(
                    margin: const EdgeInsets.only(
                      top: UniversalConstants.spacingSmall,
                    ),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        UniversalConstants.spacingXSmall,
                      ),
                    ),
                  ),
                Flexible(child: child),
              ],
            ),
          ),
        ),
      );
    },
  );
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
    Key? key,
    this.title,
    this.icon,
    required this.child,
    this.actions,
    this.contentPadding = const EdgeInsets.all(
      UniversalConstants.spacingMedium,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    style: const TextStyle(
                      fontSize: 18,
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
