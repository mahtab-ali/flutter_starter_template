import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../../config/localization/app_localizations.dart';
import '../../../config/themes/app_gradients.dart';
import '../../../core/constants/universal_constants.dart';
import '../../../core/utils/validators.dart';
import '../../common/widgets/buttons/gradient_button.dart';
import '../../common/widgets/inputs/custom_text_field.dart';
import 'auth_helper_text.dart';

class ForgotPasswordForm extends StatefulWidget {
  final bool isLoading;
  final Function(String email) onSubmit;

  const ForgotPasswordForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _resetPassword() {
    widget.onSubmit(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final i18n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Helper Text for Forgot Password
        AuthHelperText(text: i18n.translate("reset_password_instruction")),

        // Email Field
        CustomTextField(
          label: i18n.translate("email"),
          hint: i18n.translate("email_hint"),
          controller: _emailController,
          focusNode: _emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _resetPassword(),
          prefixIcon: Icon(LineIcons.envelope, color: theme.iconTheme.color),
          validator: (value) => Validators.validateEmail(value),
          borderColor:
              isDark ? Colors.white.withAlpha(25) : Colors.black.withAlpha(25),
        ),
        const SizedBox(height: UniversalConstants.spacingLarge),

        // Reset Password Button
        GradientButton(
          text: i18n.translate("reset_password"),
          isLoading: widget.isLoading,
          onPressed: _resetPassword,
          gradient: AppGradients.primaryDiagonal(isDark: isDark),
        ),
      ],
    );
  }
}
