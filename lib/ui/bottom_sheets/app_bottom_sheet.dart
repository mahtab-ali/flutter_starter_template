import 'package:flutter/material.dart';

import '../../i18n/app_localizations.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/universal_constants.dart';
import '../buttons/primary_button.dart';

/// Shows an app-style bottom sheet without blur effect on background
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool enableDrag = true,
  double? height,
  bool showDragHandle = true,
  Color? backgroundColor,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    // Ensure bottom sheet spans edge-to-edge
    useRootNavigator: true,
    barrierColor: Colors.black.withAlpha(200),
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(UniversalConstants.borderRadiusXLarge),
                topRight: Radius.circular(
                  UniversalConstants.borderRadiusXLarge,
                ),
              ),
              color: backgroundColor ?? theme.colorScheme.surface,
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withAlpha(25),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  spreadRadius: 2,
                  color: theme.colorScheme.onSurface.withAlpha(20),
                ),
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
        ),
      );
    },
  );
}

/// A specialized widget to be used inside app bottom sheets
/// that creates a visually pleasing layout
class AppBottomSheetContent extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final EdgeInsets contentPadding;

  const AppBottomSheetContent({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.contentPadding = const EdgeInsets.all(
      UniversalConstants.spacingMedium,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = AppLocalizations.of(context).locale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(
              top: UniversalConstants.spacingMedium,
              left: UniversalConstants.spacingMedium,
              right: UniversalConstants.spacingMedium,
            ),
            child: Center(
              child: Text(
                title!,
                style:
                    isDark
                        ? AppTextStyles.headingSmallDark(locale: locale)
                        : AppTextStyles.headingSmallLight(locale: locale),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        Flexible(child: Padding(padding: contentPadding, child: child)),
        if (actions != null && actions!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(UniversalConstants.spacingMedium),
            child: Center(
              child: Wrap(
                spacing: UniversalConstants.spacingSmall,
                runSpacing: UniversalConstants.spacingSmall,
                alignment: WrapAlignment.center,
                children: _processActionButtons(actions!),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _processActionButtons(List<Widget> actionButtons) {
    return actionButtons.map((action) {
      // Convert ElevatedButton to PrimaryButton
      if (action is ElevatedButton) {
        final VoidCallback? onPressed = action.onPressed;
        final buttonChild = action.child;
        final String buttonText =
            (buttonChild is Text) ? buttonChild.data ?? 'OK' : 'OK';

        return PrimaryButton(
          text: buttonText,
          onPressed: onPressed,
          minWidth: 120,
        );
      }
      // Convert TextButton to PrimaryButton.text
      else if (action is TextButton) {
        final VoidCallback? onPressed = action.onPressed;
        final buttonChild = action.child;
        final String buttonText =
            (buttonChild is Text) ? buttonChild.data ?? 'Cancel' : 'Cancel';

        return PrimaryButton.text(
          text: buttonText,
          onPressed: onPressed ?? () {},
          minWidth: 120,
        );
      }
      // If it's already a PrimaryButton or something else, return as is
      return action;
    }).toList();
  }
}
