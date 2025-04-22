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
import '../../utils/validators.dart';
import '../../widgets/app_bar_actions.dart';
import '../../screens/home_screen.dart';
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

  // Add focus nodes
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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

  // Handle moving to the next field
  void _fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AppAuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);

          if (state is AuthError) {
            ToastUtil.showError(context, state.message);
          } else if (state is AuthAuthenticated) {
            // Navigate to home screen on successful authentication
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: const [
            AppBarActions(), // Added theme/language options
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(UniversalConstants.spacingLarge),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo with styled icon
                    Center(
                      child: Icon(
                        LineIcons.rocket,
                        size: 60,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: UniversalConstants.spacingMedium),

                    // App Name
                    Text(
                      AppLocalizations.of(context).translate('app_name'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: UniversalConstants.spacingXLarge),

                    // Form container with theme-aware background
                    Container(
                      padding: const EdgeInsets.all(
                        UniversalConstants.spacingLarge,
                      ),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(
                          UniversalConstants.borderRadiusLarge,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withAlpha(25),
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
                            style: theme.textTheme.headlineSmall?.copyWith(
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
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted:
                                (_) => _fieldFocusChange(
                                  context,
                                  _emailFocusNode,
                                  _passwordFocusNode,
                                ),
                            prefixIcon: Icon(
                              LineIcons.envelope,
                              color: theme.iconTheme.color,
                            ),
                            validator:
                                (value) => Validators.validateEmail(value),
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
                            focusNode: _passwordFocusNode,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _login(),
                            prefixIcon: Icon(
                              LineIcons.lock,
                              color: theme.iconTheme.color,
                            ),
                            validator:
                                (value) => Validators.validatePassword(value),
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
                              isDark: isDark,
                            ),
                          ),

                          const SizedBox(
                            height: UniversalConstants.spacingMedium,
                          ),

                          // Forgot Password link (moved below login button)
                          Align(
                            alignment: Alignment.center,
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
                                  color: theme.colorScheme.primary,
                                ),
                              ),
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
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                          ),
                          child: Text(
                            AppLocalizations.of(context).translate('register'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
