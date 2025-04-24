import 'package:flutter/material.dart';
import '../../../config/localization/app_localizations.dart';
import '../../../config/themes/app_text_styles.dart';

class AuthFooter extends StatelessWidget {
  final String messageText;
  final String actionText;
  final VoidCallback onActionPressed;

  const AuthFooter({
    super.key,
    required this.messageText,
    required this.actionText,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final i18n = AppLocalizations.of(context);
    final locale = i18n.locale;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          messageText,
          style:
              isDark
                  ? AppTextStyles.bodyMediumDark(locale: locale)
                  : AppTextStyles.bodyMediumLight(locale: locale),
        ),
        TextButton(
          onPressed: onActionPressed,
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
          ),
          child: Text(
            actionText,
            style:
                isDark
                    ? AppTextStyles.bodyMediumDark(
                      locale: locale,
                    ).copyWith(fontWeight: FontWeight.bold)
                    : AppTextStyles.bodyMediumLight(
                      locale: locale,
                    ).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
