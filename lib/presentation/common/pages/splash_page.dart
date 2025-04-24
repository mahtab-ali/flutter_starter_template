import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/routes.dart';
import '../../../presentation/auth/bloc/app_auth_bloc.dart';
import '../../../presentation/auth/bloc/app_auth_event.dart';
import '../../../presentation/auth/bloc/app_auth_state.dart';
import '../../../presentation/onboarding/bloc/onboarding_bloc.dart';
import '../../../presentation/onboarding/bloc/onboarding_event.dart';
import '../../../presentation/onboarding/bloc/onboarding_state.dart';

/// Splash screen of the application
/// This is the entry point of the app
class SplashPage extends StatefulWidget {
  /// Create a new SplashPage
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  /// Check the application state and navigate accordingly
  Future<void> _checkAppState() async {
    // This delay is just for demonstration purposes
    await Future.delayed(const Duration(seconds: 2));

    // Check authentication and onboarding status
    if (!mounted) return;

    context.read<AppAuthBloc>().add(AuthCheckRequested());
    context.read<OnboardingBloc>().add(OnboardingCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AppAuthBloc, AppAuthState>(
        listener: (context, authState) {
          _handleAuthStateChange(context, authState);
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo or name
              const FlutterLogo(size: 100),
              const SizedBox(height: 16),
              Text(
                'Flutter Starter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AppAuthState authState) {
    final onboardingState = context.read<OnboardingBloc>().state;

    if (authState is AuthUnauthenticated) {
      if (onboardingState is! OnboardingFinished) {
        AppRoutes.navigateAndRemoveUntil(context, AppRoutes.onboarding);
      } else {
        AppRoutes.navigateAndRemoveUntil(context, AppRoutes.login);
      }
    } else if (authState is AuthAuthenticated) {
      AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
    }
    // Otherwise still loading or in initial state
  }
}
