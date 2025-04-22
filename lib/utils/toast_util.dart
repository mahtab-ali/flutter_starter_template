import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ToastUtil {
  static void showSuccess(BuildContext context, String message) {
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.scale,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
      position: StyledToastPosition.bottom,
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }

  static void showError(BuildContext context, String message) {
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.scale,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      position: StyledToastPosition.bottom,
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }

  static void showInfo(BuildContext context, String message) {
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.scale,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.blue,
      position: StyledToastPosition.bottom,
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}
