import 'package:flutter/material.dart';
import 'package:starter_template_flutter/config/localization/app_localizations.dart';
import 'package:starter_template_flutter/config/themes/app_text_styles.dart';

class HomeWelcomeSection extends StatelessWidget {
  final String displayName;

  const HomeWelcomeSection({super.key, required this.displayName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);
    final locale = i18n.locale;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          i18n.translate('flutter_starter_template'),
          style:
              isDark
                  ? AppTextStyles.headingLargeDark(locale: locale)
                  : AppTextStyles.headingLargeLight(locale: locale),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          i18n.translate('welcome_message').replaceAll('{name}', displayName),
          style:
              isDark
                  ? AppTextStyles.bodyLargeDark(locale: locale)
                  : AppTextStyles.bodyLargeLight(locale: locale),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
