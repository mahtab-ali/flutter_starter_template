import 'package:flutter/material.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';

/// Application routes definition
/// Use this class for all navigation instead of direct MaterialPageRoute instantiation
class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String settings = '/settings';

  /// The route generator callback used by the MaterialApp
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String? routeName = settings.name;

    if (routeName == splash) {
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    } else if (routeName == onboarding) {
      return MaterialPageRoute(builder: (_) => const OnboardingScreen());
    } else if (routeName == login) {
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    } else if (routeName == register) {
      return MaterialPageRoute(builder: (_) => const RegisterScreen());
    } else if (routeName == forgotPassword) {
      return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
    } else if (routeName == home) {
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    } else if (routeName == AppRoutes.settings) {
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    } else {
      // If there is no such named route, return a 404 page
      return MaterialPageRoute(
        builder:
            (_) => Scaffold(
              body: Center(child: Text('Route $routeName not found')),
            ),
      );
    }
  }

  /// Navigate to a named route
  static Future<T?> navigateTo<T>(BuildContext context, String routeName) {
    return Navigator.of(context).pushNamed(routeName);
  }

  /// Navigate to a named route and remove all previous routes
  static Future<T?> navigateAndRemoveUntil<T>(
    BuildContext context,
    String routeName,
  ) {
    return Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  /// Navigate to a named route and replace the current route
  static Future<T?> navigateAndReplace<T>(
    BuildContext context,
    String routeName,
  ) {
    return Navigator.of(context).pushReplacementNamed(routeName);
  }
}
