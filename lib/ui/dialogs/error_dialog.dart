import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../themes/app_gradients.dart';
import 'custom_alert_dialog.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String? confirmText;
  final String? cancelText;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    required this.message,
    this.onConfirm,
    this.onCancel,
    this.confirmText,
    this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (onCancel != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel!();
          },
          child: Text(cancelText ?? 'Cancel'),
        ),
      );
    }

    if (onConfirm != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm!();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          ),
          child: Text(confirmText ?? 'OK'),
        ),
      );
    } else {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          ),
          child: Text(confirmText ?? 'OK'),
        ),
      );
    }

    return CustomAlertDialog(
      title: title,
      message: message,
      icon: const Icon(
        LineIcons.exclamationTriangle,
        color: Colors.red,
        size: 50,
      ),
      actions: actions,
      gradient: AppGradients.glassLight(isDark: false),
    );
  }

  // Show dialog static helper
  static Future<void> show(
    BuildContext context, {
    String title = 'Error',
    required String message,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String? confirmText,
    String? cancelText,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => ErrorDialog(
            title: title,
            message: message,
            onConfirm: onConfirm,
            onCancel: onCancel,
            confirmText: confirmText,
            cancelText: cancelText,
          ),
    );
  }
}
