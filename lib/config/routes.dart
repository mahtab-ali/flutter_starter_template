import 'package:flutter/material.dart';
import '../presentation/auth/pages/forgot_password_page.dart';
import '../presentation/auth/pages/login_page.dart';
import '../presentation/auth/pages/register_page.dart';
import '../presentation/home/pages/home_page.dart';
import '../presentation/onboarding/pages/onboarding_page.dart';
import '../presentation/profile/pages/profile_page.dart';
import '../presentation/settings/pages/settings_page.dart';
import '../presentation/common/pages/splash_page.dart';

/// Application routes definition
/// Use this class for all navigation instead of direct MaterialPageRoute instantiation
class AppRoutes {
  AppRoutes._(); // Private constructor to prevent instantiation

  // Route names
  // Authentication routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main app routes
  static const String home = '/home';
  static const String settings = '/settings';
  static const String profile = '/profile';

  /// The route generator callback used by the MaterialApp
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String? routeName = settings.name;

    switch (routeName) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
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
