import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../themes/app_gradients.dart';
import 'custom_alert_dialog.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final String? confirmText;

  const SuccessDialog({
    super.key,
    this.title = 'Success',
    required this.message,
    this.onConfirm,
    this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    actions.add(
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          if (onConfirm != null) {
            onConfirm!();
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
        ),
        child: Text(confirmText ?? 'OK'),
      ),
    );

    return CustomAlertDialog(
      title: title,
      message: message,
      icon: const Icon(LineIcons.checkCircle, color: Colors.green, size: 50),
      actions: actions,
      gradient: AppGradients.glassLight(isDark: false),
    );
  }

  // Show dialog static helper
  static Future<void> show(
    BuildContext context, {
    String title = 'Success',
    required String message,
    VoidCallback? onConfirm,
    String? confirmText,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => SuccessDialog(
            title: title,
            message: message,
            onConfirm: onConfirm,
            confirmText: confirmText,
          ),
    );
  }
}
