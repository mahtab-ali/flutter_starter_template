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

  // Add focus nodes
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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
            ToastUtil.showSuccess(context, 'Registration successful!');
            // Navigate to home screen after successful registration
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
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
          actions: const [
            AppBarActions(), // Added theme/language options
          ],
        ),
        body: SafeArea(
          child: Center(
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
                          LineIcons.userPlus,
                          size: 60,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: UniversalConstants.spacingMedium),

                      // App Name
                      Text(
                        AppLocalizations.of(context).translate('register'),
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
                            // Registration text
                            Text(
                              'Create your account',
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
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted:
                                  (_) => _fieldFocusChange(
                                    context,
                                    _passwordFocusNode,
                                    _confirmPasswordFocusNode,
                                  ),
                              obscureText: true,
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

                            // Confirm Password Field
                            CustomTextField(
                              label: AppLocalizations.of(
                                context,
                              ).translate('confirm_password'),
                              hint: '••••••••',
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocusNode,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _register(),
                              obscureText: true,
                              prefixIcon: Icon(
                                LineIcons.lock,
                                color: theme.iconTheme.color,
                              ),
                              validator:
                                  (value) => Validators.validatePasswordMatch(
                                    _passwordController.text,
                                    value,
                                  ),
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
                                isDark: isDark,
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
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
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
    );
  }
}
