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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _resetSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AppAuthBloc>().add(
        AuthResetPasswordRequested(email: _emailController.text.trim()),
      );
      // We'll show a success message when the state updates
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
          } else if (state is AuthUnauthenticated) {
            // This means the password reset email was sent successfully
            setState(() => _resetSent = true);
            ToastUtil.showSuccess(
              context,
              'Password reset link sent to your email',
            );
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
            gradient: AppGradients.primaryVertical(isDark: false),
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
                          LineIcons.key,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: UniversalConstants.spacingMedium,
                        ),

                        // Forgot Password Title
                        Text(
                          AppLocalizations.of(
                            context,
                          ).translate('forgot_password'),
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
                              if (!_resetSent) ...[
                                const Text(
                                  'Enter your email address to reset your password',
                                  style: TextStyle(fontSize: 16),
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
                                  height: UniversalConstants.spacingLarge,
                                ),

                                // Reset Password Button
                                GradientButton(
                                  text: AppLocalizations.of(
                                    context,
                                  ).translate('reset_password'),
                                  isLoading: _isLoading,
                                  onPressed: _resetPassword,
                                  gradient: AppGradients.primaryDiagonal(
                                    isDark: false,
                                  ),
                                ),
                              ] else ...[
                                // Success Message
                                const Icon(
                                  LineIcons.checkCircle,
                                  color: Colors.green,
                                  size: 50,
                                ),
                                const SizedBox(
                                  height: UniversalConstants.spacingMedium,
                                ),
                                const Text(
                                  'Password reset link sent!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(
                                  height: UniversalConstants.spacingMedium,
                                ),
                                Text(
                                  'We have sent a password reset link to ${_emailController.text}. Please check your email and follow the instructions to reset your password.',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: UniversalConstants.spacingLarge,
                                ),

                                // Back to Login Button
                                GradientButton(
                                  text: AppLocalizations.of(
                                    context,
                                  ).translate('back_to_login'),
                                  onPressed: () => Navigator.pop(context),
                                  gradient: AppGradients.primaryDiagonal(
                                    isDark: false,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: UniversalConstants.spacingMedium,
                        ),

                        // Back to login
                        if (!_resetSent)
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                ).translate('back_to_login'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
