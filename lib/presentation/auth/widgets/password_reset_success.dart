import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../../config/localization/app_localizations.dart';
import '../../../config/themes/app_gradients.dart';
import '../../../config/themes/app_text_styles.dart';
import '../../../core/constants/universal_constants.dart';
import '../../common/widgets/buttons/gradient_button.dart';

class PasswordResetSuccess extends StatelessWidget {
  final String email;
  final VoidCallback onBackToLogin;

  const PasswordResetSuccess({
    super.key,
    required this.email,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final i18n = AppLocalizations.of(context);
    final locale = i18n.locale;

    return Column(
      children: [
        // Success Icon
        Center(
          child: Icon(
            LineIcons.checkCircle,
            color: theme.colorScheme.primary,
            size: 60,
          ),
        ),
        const SizedBox(height: UniversalConstants.spacingLarge),

        // Success Title
        Center(
          child: Text(
            i18n.translate("reset_password_success_title"),
            style:
                isDark
                    ? AppTextStyles.headingSmallDark(locale: locale).copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    )
                    : AppTextStyles.headingSmallLight(locale: locale).copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
          ),
        ),
        const SizedBox(height: UniversalConstants.spacingMedium),

        // Success Message
        Text(
          i18n.translateWithArgs("reset_password_success_message", {
            "email": email,
          }),
          style:
              isDark
                  ? AppTextStyles.bodyMediumDark(locale: locale)
                  : AppTextStyles.bodyMediumLight(locale: locale),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: UniversalConstants.spacingLarge),

        // Back to Login Button
        GradientButton(
          text: i18n.translate("back_to_login"),
          onPressed: onBackToLogin,
          gradient: AppGradients.primaryDiagonal(isDark: isDark),
        ),
      ],
    );
  }
}
