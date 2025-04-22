import 'package:flutter/material.dart';
import '../../themes/app_gradients.dart';
import '../../themes/universal_constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Widget? icon;
  final List<Widget> actions;
  final Gradient? gradient;
  final bool showCloseButton;
  final EdgeInsets contentPadding;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.actions = const [],
    this.gradient,
    this.showCloseButton = true,
    this.contentPadding = const EdgeInsets.all(UniversalConstants.spacingLarge),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          UniversalConstants.borderRadiusLarge,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient:
              gradient ??
              (isDark
                  ? AppGradients.glassDark(isDark: isDark)
                  : AppGradients.glassLight(isDark: isDark)),
          borderRadius: BorderRadius.circular(
            UniversalConstants.borderRadiusLarge,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showCloseButton)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            Padding(
              padding: contentPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: UniversalConstants.spacingMedium,
                      ),
                      child: icon,
                    ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: UniversalConstants.spacingMedium),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (actions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: UniversalConstants.spacingLarge,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            actions.map((action) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: UniversalConstants.spacingXSmall,
                                ),
                                child: action,
                              );
                            }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
