import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:starter_template_flutter/ui/bottom_sheets/app_bottom_sheet.dart';

import '../blocs/localization/localization_bloc.dart';
import '../blocs/localization/localization_event.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import '../i18n/app_localizations.dart';

class AppBarActions extends StatelessWidget {
  final bool showThemeToggle;
  final bool showLanguageSelector;
  final bool groupActions;

  const AppBarActions({
    super.key,
    this.showThemeToggle = true,
    this.showLanguageSelector = true,
    this.groupActions = true,
  });

  @override
  Widget build(BuildContext context) {
    if (groupActions) {
      return Row(
        children: [
          if (showLanguageSelector) _buildLanguageButton(context),
          if (showThemeToggle) _buildThemeToggleButton(context),
        ],
      );
    } else {
      return showThemeToggle
          ? _buildThemeToggleButton(context)
          : _buildLanguageButton(context);
    }
  }

  Widget _buildLanguageButton(BuildContext context) {
    return IconButton(
      icon: const Icon(LineIcons.language),
      onPressed: () => _showLanguageBottomSheet(context),
      tooltip: AppLocalizations.of(context).translate('language'),
    );
  }

  Widget _buildThemeToggleButton(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
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
          icon: Icon(isDarkMode ? LineIcons.sun : LineIcons.moon),
          onPressed: () {
            // Toggle between light and dark mode directly
            if (state.isSystemTheme) {
              // If system theme is on, switch to explicit light or dark based on current state
              context.read<ThemeBloc>().add(
                ThemeChanged(isDarkMode: !isDarkMode),
              );
            } else {
              // If already in explicit mode, just toggle
              context.read<ThemeBloc>().add(
                ThemeChanged(isDarkMode: !state.isDarkMode!),
              );
            }
          },
          tooltip:
              isDarkMode
                  ? AppLocalizations.of(context).translate('light_mode')
                  : AppLocalizations.of(context).translate('dark_mode'),
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);

    showAppBottomSheet(
      context: context,
      child: AppBottomSheetContent(
        title: i18n.translate('select_language'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // English option
            ListTile(
              leading: const Text(
                '🇺🇸',
                style: TextStyle(fontSize: 32), // Increased size from default
              ),
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
              leading: const Text(
                '🇸🇦',
                style: TextStyle(fontSize: 32), // Increased size from default
              ),
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
}
