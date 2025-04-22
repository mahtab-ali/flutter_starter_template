import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../../blocs/auth/app_auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../i18n/app_localizations.dart';
import '../../themes/app_gradients.dart';
import '../../themes/universal_constants.dart';
import '../../ui/buttons/gradient_button.dart';
import '../../ui/inputs/custom_text_field.dart';
import '../../utils/toast_util.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AppAuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppAuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);

          if (state is AuthError) {
            ToastUtil.showError(context, state.message);
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.glassLight(isDark: false),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(
                    UniversalConstants.spacingLarge,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // App Logo
                        const Icon(
                          LineIcons.rocket,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: UniversalConstants.spacingMedium,
                        ),

                        // App Name
                        Text(
                          AppLocalizations.of(context).translate('app_name'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: UniversalConstants.spacingXLarge,
                        ),

                        // White rounded container for form
                        Container(
                          padding: const EdgeInsets.all(
                            UniversalConstants.spacingLarge,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              UniversalConstants.borderRadiusLarge,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Login text
                              Text(
                                AppLocalizations.of(context).translate('login'),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: UniversalConstants.spacingLarge,
                              ),

                              // Email Field
                              CustomTextField(
                                label: AppLocalizations.of(
                                  context,
                                ).translate('email'),
                                hint: 'example@email.com',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(LineIcons.envelope),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@') ||
                                      !value.contains('.')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: UniversalConstants.spacingMedium,
                              ),

                              // Password Field
                              CustomTextField(
                                label: AppLocalizations.of(
                                  context,
                                ).translate('password'),
                                hint: '••••••••',
                                controller: _passwordController,
                                obscureText: true,
                                prefixIcon: const Icon(LineIcons.lock),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: UniversalConstants.spacingMedium,
                              ),

                              // Forgot Password link
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    ).translate('forgot_password'),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: UniversalConstants.spacingMedium,
                              ),

                              // Login Button
                              GradientButton(
                                text: AppLocalizations.of(
                                  context,
                                ).translate('login'),
                                isLoading: _isLoading,
                                onPressed: _login,
                                gradient: AppGradients.primaryDiagonal(
                                  isDark: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: UniversalConstants.spacingLarge),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account? ',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                ).translate('register'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
