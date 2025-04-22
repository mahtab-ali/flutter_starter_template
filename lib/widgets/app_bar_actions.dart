import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../blocs/localization/localization_bloc.dart';
import '../blocs/localization/localization_event.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import '../i18n/app_localizations.dart';
import '../ui/bottom_sheets/ios_bottom_sheet.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Language selector icon
        IconButton(
          icon: const Icon(LineIcons.language),
          onPressed: () => _showLanguageBottomSheet(context),
          tooltip: AppLocalizations.of(context).translate('language'),
        ),
        // Theme selector icon - shows sun/moon based on current theme
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            final bool isDarkMode;
            if (state.isSystemTheme) {
              // If system theme, check the current brightness
              final brightness = MediaQuery.platformBrightnessOf(context);
              isDarkMode = brightness == Brightness.dark;
            } else {
              // Otherwise use the selected theme
              isDarkMode = state.isDarkMode == true;
            }

            return IconButton(
              icon: Icon(isDarkMode ? LineIcons.moon : LineIcons.sun),
              onPressed: () => _showThemeBottomSheet(context),
              tooltip: AppLocalizations.of(context).translate('theme'),
            );
          },
        ),
      ],
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);

    showIosBottomSheet(
      context: context,
      child: IosBottomSheetContent(
        title: i18n.translate('select_language'),
        icon: Icon(LineIcons.language, color: theme.iconTheme.color),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // English option
            ListTile(
              leading: const Text('🇺🇸'),
              title: Text(
                i18n.translate('english'),
                style: theme.textTheme.bodyLarge,
              ),
              trailing:
                  i18n.locale.languageCode == 'en'
                      ? Icon(LineIcons.check, color: theme.colorScheme.primary)
                      : null,
              onTap: () {
                context.read<LocalizationBloc>().add(
                  LocaleChanged(languageCode: 'en'),
                );
                Navigator.pop(context);
              },
            ),
            // Arabic option
            ListTile(
              leading: const Text('🇸🇦'),
              title: Text(
                i18n.translate('arabic'),
                style: theme.textTheme.bodyLarge,
              ),
              trailing:
                  i18n.locale.languageCode == 'ar'
                      ? Icon(LineIcons.check, color: theme.colorScheme.primary)
                      : null,
              onTap: () {
                context.read<LocalizationBloc>().add(
                  LocaleChanged(languageCode: 'ar'),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);

    showIosBottomSheet(
      context: context,
      child: IosBottomSheetContent(
        title: i18n.translate('theme'),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // System theme option
                ListTile(
                  leading: Icon(
                    LineIcons.desktop,
                    color:
                        state.isSystemTheme ? theme.colorScheme.primary : null,
                  ),
                  title: Text("System Theme", style: theme.textTheme.bodyLarge),

                  trailing:
                      state.isSystemTheme
                          ? Icon(
                            LineIcons.check,
                            color: theme.colorScheme.primary,
                          )
                          : null,
                  onTap: () {
                    context.read<ThemeBloc>().add(UseSystemTheme());
                    Navigator.pop(context);
                  },
                ),
                // Light theme option
                ListTile(
                  leading: Icon(
                    LineIcons.sun,
                    color:
                        !state.isSystemTheme && state.isDarkMode == false
                            ? theme.colorScheme.primary
                            : null,
                  ),
                  title: Text("Light Mode", style: theme.textTheme.bodyLarge),
                  trailing:
                      !state.isSystemTheme && state.isDarkMode == false
                          ? Icon(
                            LineIcons.check,
                            color: theme.colorScheme.primary,
                          )
                          : null,
                  onTap: () {
                    context.read<ThemeBloc>().add(
                      ThemeChanged(isDarkMode: false),
                    );
                    Navigator.pop(context);
                  },
                ),
                // Dark theme option
                ListTile(
                  leading: Icon(
                    LineIcons.moon,
                    color:
                        !state.isSystemTheme && state.isDarkMode == true
                            ? theme.colorScheme.primary
                            : null,
                  ),
                  title: Text("Dark Mode", style: theme.textTheme.bodyLarge),
                  trailing:
                      !state.isSystemTheme && state.isDarkMode == true
                          ? Icon(
                            LineIcons.check,
                            color: theme.colorScheme.primary,
                          )
                          : null,
                  onTap: () {
                    context.read<ThemeBloc>().add(
                      ThemeChanged(isDarkMode: true),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
