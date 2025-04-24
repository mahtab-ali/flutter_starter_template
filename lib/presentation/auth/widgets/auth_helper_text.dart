import 'package:flutter/material.dart';
import '../../../config/themes/app_text_styles.dart';
import '../../../core/constants/universal_constants.dart';

class AuthHelperText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const AuthHelperText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);

    return Column(
      children: [
        Text(
          text,
          style:
              isDark
                  ? AppTextStyles.bodyMediumDark(locale: locale)
                  : AppTextStyles.bodyMediumLight(locale: locale),
          textAlign: textAlign,
        ),
        const SizedBox(height: UniversalConstants.spacingLarge),
      ],
    );
  }
}
