import 'package:flutter/material.dart';

/// Utility class for keyboard operations
class KeyboardUtil {
  /// Hides the keyboard
  static void hideKeyboard(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// Determines if the keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// Adds a listener to dismiss keyboard when tapping outside of form fields
  static void setupKeyboardDismissal(Widget child) {
    GestureDetector(
      onTap: () {
        // This will hide the keyboard when tapping anywhere on the screen
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
