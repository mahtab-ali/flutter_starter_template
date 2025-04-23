import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../i18n/app_localizations.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/universal_constants.dart';
import '../buttons/primary_button.dart';

enum AlertType { info, success, error, warning, custom }

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Widget? icon;
  final Color? iconColor;
  final List<Widget> actions;
  final bool showCloseButton;
  final EdgeInsets contentPadding;
  final AlertType alertType;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
    this.actions = const [],
    this.showCloseButton = true,
    this.contentPadding = const EdgeInsets.all(
      UniversalConstants.spacingXLarge,
    ),
    this.alertType = AlertType.custom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = AppLocalizations.of(context).locale;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          UniversalConstants.borderRadiusLarge,
        ),
      ),
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: UniversalConstants.spacingMedium,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(
            UniversalConstants.borderRadiusLarge,
          ),
          border: Border.all(
            color: (isDark ? Colors.white : Colors.black).withAlpha(25),
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                UniversalConstants.spacingXLarge,
                UniversalConstants.spacingMedium,
                UniversalConstants.spacingXLarge,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style:
                          isDark
                              ? AppTextStyles.headingSmallDark(locale: locale)
                              : AppTextStyles.headingSmallLight(locale: locale),
                    ),
                  ),
                  if (showCloseButton)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                ],
              ),
            ),
            Padding(
              padding: contentPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null || alertType != AlertType.custom)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: UniversalConstants.spacingMedium,
                      ),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Center(
                          child: icon ?? _getIconForType(alertType, theme),
                        ),
                      ),
                    ),
                  const SizedBox(height: UniversalConstants.spacingMedium),
                  Text(
                    message,
                    style:
                        isDark
                            ? AppTextStyles.bodyLargeDark(locale: locale)
                            : AppTextStyles.bodyLargeLight(locale: locale),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: UniversalConstants.spacingXXLarge),
                  if (actions.isNotEmpty)
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: UniversalConstants.spacingMedium,
                        runSpacing: UniversalConstants.spacingMedium,
                        children: actions,
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

  Widget _getIconForType(AlertType type, ThemeData theme) {
    final Color color = _getColorForType(type, theme);
    final double iconSize = 60.0;

    switch (type) {
      case AlertType.success:
        return Icon(LineIcons.checkCircle, color: color, size: iconSize);
      case AlertType.error:
        return Icon(
          LineIcons.exclamationTriangle,
          color: color,
          size: iconSize,
        );
      case AlertType.warning:
        return Icon(LineIcons.exclamation, color: color, size: iconSize);
      case AlertType.info:
        return Icon(LineIcons.infoCircle, color: color, size: iconSize);
      case AlertType.custom:
        return const SizedBox.shrink();
    }
  }

  Color _getColorForType(AlertType type, ThemeData theme) {
    switch (type) {
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.warning:
        return Colors.amber;
      case AlertType.info:
        return Colors.blue;
      case AlertType.custom:
        return theme.colorScheme.primary;
    }
  }

  // Static helper methods for different alert types
  static Future<void> showInfo(
    BuildContext context, {
    String title = 'Information',
    required String message,
    List<Widget> actions = const [],
    bool showCloseButton = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(200),
      builder:
          (context) => CustomAlertDialog(
            title: title,
            message: message,
            actions:
                actions.isEmpty
                    ? [
                      PrimaryButton(
                        text: 'OK',
                        minWidth: 120,
                        onPressed: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(
                          UniversalConstants.borderRadiusFull,
                        ),
                      ),
                    ]
                    : actions,
            showCloseButton: showCloseButton,
            alertType: AlertType.info,
          ),
    );
  }

  static Future<void> showSuccess(
    BuildContext context, {
    String title = 'Success',
    required String message,
    VoidCallback? onConfirm,
    String confirmText = 'OK',
    List<Widget>? customActions,
  }) {
    final List<Widget> actions =
        customActions ??
        [
          PrimaryButton(
            text: confirmText,
            minWidth: 120,
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) {
                onConfirm();
              }
            },
            backgroundColor: Colors.green,
            borderRadius: BorderRadius.circular(
              UniversalConstants.borderRadiusFull,
            ),
          ),
        ];

    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(200),
      builder:
          (context) => CustomAlertDialog(
            title: title,
            message: message,
            actions: actions,
            showCloseButton: false,
            alertType: AlertType.success,
          ),
    );
  }

  static Future<void> showError(
    BuildContext context, {
    String title = 'Error',
    required String message,
    VoidCallback? onConfirm,
    String confirmText = 'OK',
    List<Widget>? customActions,
  }) {
    final List<Widget> actions =
        customActions ??
        [
          PrimaryButton(
            text: confirmText,
            minWidth: 120,
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) {
                onConfirm();
              }
            },
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(
              UniversalConstants.borderRadiusFull,
            ),
          ),
        ];

    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(200),
      builder:
          (context) => CustomAlertDialog(
            title: title,
            message: message,
            actions: actions,
            showCloseButton: false,
            alertType: AlertType.error,
          ),
    );
  }

  static Future<void> showConfirmation(
    BuildContext context, {
    String title = 'Confirmation',
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) {
    final List<Widget> actions = [
      PrimaryButton.text(
        text: cancelText,
        minWidth: 120,

        onPressed: () {
          Navigator.of(context).pop();
          if (onCancel != null) {
            onCancel();
          }
        },
        borderRadius: BorderRadius.circular(
          UniversalConstants.borderRadiusFull,
        ),
      ),
      PrimaryButton(
        text: confirmText,
        minWidth: 120,
        onPressed: () {
          Navigator.of(context).pop();
          onConfirm();
        },
        borderRadius: BorderRadius.circular(
          UniversalConstants.borderRadiusFull,
        ),
      ),
    ];

    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(200),
      builder:
          (context) => CustomAlertDialog(
            title: title,
            message: message,
            actions: actions,
            showCloseButton: false,
            alertType: AlertType.warning,
          ),
    );
  }
}
