import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:starter_template_flutter/blocs/auth/app_auth_bloc.dart';
import 'package:starter_template_flutter/blocs/auth/auth_state.dart';
import 'package:starter_template_flutter/screens/auth/login_screen.dart';
import 'package:starter_template_flutter/screens/home/home_screen.dart';
import 'package:starter_template_flutter/themes/universal_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  double _loadingValue = 0.0;

  @override
  void initState() {
    super.initState();

    // Start timer to increment loading indicator
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _loadingValue += 0.016; // Will reach 1.0 in approximately 3 seconds

        // Auto navigate after 3 seconds
        if (_loadingValue >= 1.0) {
          _timer.cancel();
          _navigateBasedOnAuthState();
        }
      });
    });
  }

  void _navigateBasedOnAuthState() {
    final authState = context.read<AppAuthBloc>().state;

    if (authState is AuthAuthenticated) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else if (authState is AuthUnauthenticated) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AppAuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated || state is AuthUnauthenticated) {
          // If auth state changes while on splash, navigate immediately
          if (_loadingValue < 1.0) {
            _timer.cancel();
            _navigateBasedOnAuthState();
          }
        }
      },
      child: Scaffold(
        // Plain background based on theme
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo or icon placeholder with new icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(
                    UniversalConstants.borderRadiusCircular,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  LineIcons.rocket, // Using rocket icon instead of smartphone
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: UniversalConstants.spacingLarge),

              // App name
              Text(
                'Flutter Starter',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),

              const SizedBox(height: UniversalConstants.spacingMedium),

              // Linear progress indicator instead of circular
              SizedBox(
                width: 200, // Small, contained size
                child: LinearProgressIndicator(
                  value: _loadingValue,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
