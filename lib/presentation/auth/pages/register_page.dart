import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:starter_template_flutter/config/localization/app_localizations.dart';
import 'package:starter_template_flutter/presentation/auth/bloc/app_auth_bloc.dart';
import 'package:starter_template_flutter/presentation/auth/bloc/app_auth_event.dart';
import 'package:starter_template_flutter/presentation/auth/bloc/app_auth_state.dart';
import 'package:starter_template_flutter/presentation/common/widgets/app_bar/custom_app_bar.dart';
import 'package:starter_template_flutter/presentation/common/widgets/buttons/gradient_button.dart';
import 'package:starter_template_flutter/presentation/common/widgets/cards/app_card.dart';
import 'package:starter_template_flutter/presentation/common/widgets/inputs/custom_text_field.dart';

import '../../../config/routes.dart';
import '../../../config/themes/app_gradients.dart';
import '../../../config/themes/app_text_styles.dart';
import '../../../core/constants/universal_constants.dart';
import '../../../core/utils/keyboard_util.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/utils/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Add focus nodes
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _register() {
    // Hide keyboard when submitting the form
    KeyboardUtil.hideKeyboard(context);

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AppAuthBloc>().add(
        AuthRegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
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
    final i18n = AppLocalizations.of(context);
    final locale = i18n.locale;

    return BlocConsumer<AppAuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ToastUtil.showError(context, state.message);
        } else if (state is AuthAuthenticated) {
          ToastUtil.showSuccess(
            context,
            i18n.translate('registration_successful'),
          );
          // Navigate to home screen after successful registration
          AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;

        return GestureDetector(
          // Add tap listener to dismiss keyboard when tapping outside
          onTap: () => KeyboardUtil.hideKeyboard(context),
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: CustomAppBar(
              title: i18n.translate('register'),
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
                              LineIcons.userPlus,
                              size: 60,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(
                            height: UniversalConstants.spacingXLarge,
                          ),

                          // Form container with theme-aware background
                          AppCard(
                            elevation: 4.0,
                            padding: const EdgeInsets.all(
                              UniversalConstants.spacingLarge,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Helper Text
                                Text(
                                  i18n.translate('register_helper_text'),
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

                                // Full Name Field
                                CustomTextField(
                                  label: i18n.translate('full_name'),
                                  hint: i18n.translate('full_name_hint'),
                                  controller: _nameController,
                                  focusNode: _nameFocusNode,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted:
                                      (_) => _fieldFocusChange(
                                        context,
                                        _nameFocusNode,
                                        _emailFocusNode,
                                      ),
                                  prefixIcon: Icon(
                                    LineIcons.user,
                                    color: theme.iconTheme.color,
                                  ),
                                  validator:
                                      (value) => Validators.validateName(value),
                                ),
                                const SizedBox(
                                  height: UniversalConstants.spacingMedium,
                                ),

                                // Email Field
                                CustomTextField(
                                  label: i18n.translate('email'),
                                  hint: i18n.translate('email_hint'),
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
                                      (value) =>
                                          Validators.validateEmail(value),
                                ),
                                const SizedBox(
                                  height: UniversalConstants.spacingMedium,
                                ),

                                // Password Field with toggle
                                CustomTextField(
                                  label: i18n.translate('password'),
                                  hint: i18n.translate('password_hint'),
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _register(),
                                  obscureText: true,
                                  showObscureTextToggle: true,
                                  prefixIcon: Icon(
                                    LineIcons.lock,
                                    color: theme.iconTheme.color,
                                  ),
                                  validator:
                                      (value) =>
                                          Validators.validatePassword(value),
                                ),
                                const SizedBox(
                                  height: UniversalConstants.spacingLarge,
                                ),

                                // Register Button
                                GradientButton(
                                  text: i18n.translate('register'),
                                  isLoading: isLoading,
                                  onPressed: _register,
                                  gradient: AppGradients.primaryDiagonal(
                                    isDark: isDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: UniversalConstants.spacingLarge,
                          ),

                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                i18n.translate('already_have_account'),
                                style:
                                    isDark
                                        ? AppTextStyles.bodyMediumDark(
                                          locale: locale,
                                        )
                                        : AppTextStyles.bodyMediumLight(
                                          locale: locale,
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
                                  i18n.translate('login'),
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
      },
    );
  }
}
