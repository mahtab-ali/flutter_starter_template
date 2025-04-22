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
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AppAuthBloc>().add(
        AuthRegisterRequested(
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
          } else if (state is AuthAuthenticated) {
            ToastUtil.showSuccess(context, 'Registration successful!');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.vibrant(isDark: false),
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
                          LineIcons.userPlus,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: UniversalConstants.spacingMedium,
                        ),

                        // App Name
                        Text(
                          AppLocalizations.of(context).translate('register'),
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
                              // Registration text
                              Text(
                                'Create your account',
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
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: UniversalConstants.spacingMedium,
                              ),

                              // Confirm Password Field
                              CustomTextField(
                                label: AppLocalizations.of(
                                  context,
                                ).translate('confirm_password'),
                                hint: '••••••••',
                                controller: _confirmPasswordController,
                                obscureText: true,
                                prefixIcon: const Icon(LineIcons.lock),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: UniversalConstants.spacingLarge,
                              ),

                              // Register Button
                              GradientButton(
                                text: AppLocalizations.of(
                                  context,
                                ).translate('register'),
                                isLoading: _isLoading,
                                onPressed: _register,
                                gradient: AppGradients.primaryDiagonal(
                                  isDark: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: UniversalConstants.spacingLarge),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: const TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                AppLocalizations.of(context).translate('login'),
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
