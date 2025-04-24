import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../../config/localization/app_localizations.dart';
import '../../../config/themes/app_gradients.dart';
import '../../../core/constants/universal_constants.dart';
import '../../../core/utils/validators.dart';
import '../../common/widgets/buttons/gradient_button.dart';
import '../../common/widgets/inputs/custom_text_field.dart';
import 'auth_helper_text.dart';

class RegisterForm extends StatefulWidget {
  final bool isLoading;
  final Function(String name, String email, String password) onSubmit;

  const RegisterForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    widget.onSubmit(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthHelperText(text: i18n.translate('register_helper_text')),

        // Full Name Field
        CustomTextField(
          label: i18n.translate('full_name'),
          hint: i18n.translate('full_name_hint'),
          controller: _nameController,
          focusNode: _nameFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted:
              (_) =>
                  _fieldFocusChange(context, _nameFocusNode, _emailFocusNode),
          prefixIcon: Icon(LineIcons.user, color: theme.iconTheme.color),
          validator: (value) => Validators.validateName(value),
        ),
        const SizedBox(height: UniversalConstants.spacingMedium),

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
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _register(),
          obscureText: true,
          showObscureTextToggle: true,
          prefixIcon: Icon(LineIcons.lock, color: theme.iconTheme.color),
          validator: (value) => Validators.validatePassword(value),
        ),
        const SizedBox(height: UniversalConstants.spacingLarge),

        // Register Button
        GradientButton(
          text: i18n.translate('register'),
          isLoading: widget.isLoading,
          onPressed: _register,
          gradient: AppGradients.primaryDiagonal(isDark: isDark),
        ),
      ],
    );
  }
}
