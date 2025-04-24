import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../../config/localization/app_localizations.dart';
import '../../../config/routes.dart';
import '../../../config/themes/app_gradients.dart';
import '../../../config/themes/app_text_styles.dart';
import '../../../core/constants/universal_constants.dart';
import '../../../core/utils/validators.dart';
import '../../common/widgets/buttons/gradient_button.dart';
import '../../common/widgets/inputs/custom_text_field.dart';
import 'auth_helper_text.dart';

class LoginForm extends StatefulWidget {
  final bool isLoading;
  final Function(String email, String password) onSubmit;

  const LoginForm({super.key, required this.isLoading, required this.onSubmit});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _login() {
    widget.onSubmit(_emailController.text.trim(), _passwordController.text);
  }

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthHelperText(text: i18n.translate('login_helper_text')),

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
          prefixIcon: Icon(LineIcons.envelope, color: theme.iconTheme.color),
          validator: (value) => Validators.validateEmail(value),
        ),
        const SizedBox(height: UniversalConstants.spacingMedium),

        // Password Field with toggle
        CustomTextField(
          label: i18n.translate('password'),
          hint: i18n.translate('password_hint'),
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: true,
          showObscureTextToggle: true,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _login(),
          prefixIcon: Icon(LineIcons.lock, color: theme.iconTheme.color),
          validator: (value) => Validators.validatePassword(value),
        ),
        const SizedBox(height: UniversalConstants.spacingLarge),

        // Login Button
        GradientButton(
          text: i18n.translate('login'),
          isLoading: widget.isLoading,
          onPressed: _login,
          gradient: AppGradients.primaryDiagonal(isDark: isDark),
        ),

        const SizedBox(height: UniversalConstants.spacingMedium),

        // Forgot Password link
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              AppRoutes.navigateTo(context, AppRoutes.forgotPassword);
            },
            child: Text(
              i18n.translate('forgot_password'),
              style:
                  isDark
                      ? AppTextStyles.bodyMediumDark(
                        locale: locale,
                      ).copyWith(color: theme.colorScheme.primary)
                      : AppTextStyles.bodyMediumLight(
                        locale: locale,
                      ).copyWith(color: theme.colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
