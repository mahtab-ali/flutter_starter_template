import 'package:flutter/material.dart';

/// Service for handling application navigation
class AppNavigator {
  final GlobalKey<NavigatorState> navigatorKey;

  /// Create a new AppNavigator with a navigator key
  AppNavigator({required this.navigatorKey});

  /// The current navigation context
  BuildContext? get context => navigatorKey.currentContext;

  /// Navigate to a named route
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Replace the current route with a new named route
  Future<T?> replaceTo<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  /// Push multiple routes and remove all previous routes
  Future<T?> navigateToAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      (_) => false,
      arguments: arguments,
    );
  }

  /// Go back to the previous route
  void goBack<T>({T? result}) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  /// Check if we can navigate back
  bool canGoBack() => navigatorKey.currentState!.canPop();

  /// Go back to the first route
  void goBackToFirst() {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
