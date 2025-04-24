import 'package:flutter/material.dart';
import 'package:starter_template_flutter/config/localization/app_localizations.dart';
import 'package:starter_template_flutter/config/themes/app_text_styles.dart';

class HomeDescriptionSection extends StatelessWidget {
  const HomeDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);
    final locale = i18n.locale;
    final isDark = theme.brightness == Brightness.dark;

    return Text(
      i18n.translate('template_description'),
      style:
          isDark
              ? AppTextStyles.bodyMediumDark(locale: locale)
              : AppTextStyles.bodyMediumLight(locale: locale),
      textAlign: TextAlign.center,
    );
  }
}
