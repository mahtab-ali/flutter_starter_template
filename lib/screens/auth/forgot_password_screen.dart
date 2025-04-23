import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import '../../blocs/auth/app_auth_bloc.dart';
import '../../blocs/auth/app_auth_event.dart';
import '../../blocs/auth/app_auth_state.dart';
import '../../i18n/app_localizations.dart';
import '../../themes/app_gradients.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/universal_constants.dart';
import '../../ui/app_bar/custom_app_bar.dart';
import '../../ui/buttons/gradient_button.dart';
import '../../ui/cards/app_card.dart';
import '../../ui/inputs/custom_text_field.dart';
import '../../utils/keyboard_util.dart';
import '../../utils/toast_util.dart';
import '../../utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _resetPassword() {
    // Hide keyboard when submitting the form
    KeyboardUtil.hideKeyboard(context);

    if (_formKey.currentState?.validate() ?? false) {
      // Use AppAuthBloc with AuthResetPasswordRequested event
      context.read<AppAuthBloc>().add(
        AuthResetPasswordRequested(email: _emailController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final i18n = AppLocalizations.of(context);
    final locale = i18n.locale;

    return BlocConsumer<AppAuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetFailure) {
          ToastUtil.showError(context, state.error);
        } else if (state is AuthPasswordResetSuccess) {
          ToastUtil.showSuccess(
            context,
            i18n.translate("reset_password_success_title"),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;
        final bool resetSent = state is AuthPasswordResetSuccess;

        return GestureDetector(
          // Add tap listener to dismiss keyboard when tapping outside
          onTap: () => KeyboardUtil.hideKeyboard(context),
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: CustomAppBar(
              title: i18n.translate("forgot_password"),
              centerTitle: false,
            ),
            body: SafeArea(
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
                          // App Logo with styled icon
                          Center(
                            child: Icon(
                              LineIcons.key,
                              size: 60,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(
                            height: UniversalConstants.spacingXLarge,
                          ),

                          // Replace Container with AppCard
                          AppCard(
                            elevation: 4.0,
                            padding: const EdgeInsets.all(
                              UniversalConstants.spacingLarge,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!resetSent) ...[
                                  // Helper Text for Forgot Password
                                  Text(
                                    i18n.translate(
                                      "reset_password_instruction",
                                    ),
                                    style:
                                        isDark
                                            ? AppTextStyles.bodyMediumDark(
                                              locale: locale,
                                            )
                                            : AppTextStyles.bodyMediumLight(
                                              locale: locale,
                                            ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: UniversalConstants.spacingLarge,
                                  ),

                                  // Email Field
                                  CustomTextField(
                                    label: i18n.translate("email"),
                                    hint: i18n.translate("email_hint"),
                                    controller: _emailController,
                                    focusNode: _emailFocusNode,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _resetPassword(),
                                    prefixIcon: Icon(
                                      LineIcons.envelope,
                                      color: theme.iconTheme.color,
                                    ),
                                    validator:
                                        (value) =>
                                            Validators.validateEmail(value),
                                    borderColor:
                                        isDark
                                            ? Colors.white.withAlpha(25)
                                            : Colors.black.withAlpha(25),
                                  ),
                                  const SizedBox(
                                    height: UniversalConstants.spacingLarge,
                                  ),

                                  // Reset Password Button
                                  GradientButton(
                                    text: i18n.translate("reset_password"),
                                    isLoading: isLoading,
                                    onPressed: _resetPassword,
                                    gradient: AppGradients.primaryDiagonal(
                                      isDark: isDark,
                                    ),
                                  ),
                                ] else ...[
                                  // Success Message
                                  Center(
                                    child: Icon(
                                      LineIcons.checkCircle,
                                      color: theme.colorScheme.primary,
                                      size: 60,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: UniversalConstants.spacingLarge,
                                  ),
                                  Center(
                                    child: Text(
                                      i18n.translate(
                                        "reset_password_success_title",
                                      ),
                                      style:
                                          isDark
                                              ? AppTextStyles.headingSmallDark(
                                                locale: locale,
                                              ).copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    theme.colorScheme.primary,
                                              )
                                              : AppTextStyles.headingSmallLight(
                                                locale: locale,
                                              ).copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: UniversalConstants.spacingMedium,
                                  ),
                                  Text(
                                    i18n.translateWithArgs(
                                      "reset_password_success_message",
                                      {"email": state.email},
                                    ),
                                    style:
                                        isDark
                                            ? AppTextStyles.bodyMediumDark(
                                              locale: locale,
                                            )
                                            : AppTextStyles.bodyMediumLight(
                                              locale: locale,
                                            ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: UniversalConstants.spacingLarge,
                                  ),

                                  // Back to Login Button
                                  GradientButton(
                                    text: i18n.translate("back_to_login"),
                                    onPressed: () => Navigator.pop(context),
                                    gradient: AppGradients.primaryDiagonal(
                                      isDark: isDark,
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
                          if (!resetSent)
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.primary,
                                ),
                                child: Text(
                                  i18n.translate("back_to_login"),
                                  style:
                                      isDark
                                          ? AppTextStyles.bodyMediumDark(
                                            locale: locale,
                                          ).copyWith(
                                            fontWeight: FontWeight.bold,
                                          )
                                          : AppTextStyles.bodyMediumLight(
                                            locale: locale,
                                          ).copyWith(
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
        );
      },
    );
  }
}
