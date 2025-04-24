import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:starter_template_flutter/config/localization/app_localizations.dart';
import 'package:starter_template_flutter/presentation/common/widgets/bottom_sheets/app_bottom_sheet.dart';

import '../../../settings/bloc/localization/localization_bloc.dart';
import '../../../settings/bloc/localization/localization_event.dart';
import '../../../settings/bloc/theme/theme_bloc.dart';
import '../../../settings/bloc/theme/theme_event.dart';
import '../../../settings/bloc/theme/theme_state.dart';

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
            // Get current language code before changing theme
            final localizationBloc = context.read<LocalizationBloc>();
            final String currentLanguage = localizationBloc.currentLanguageCode;

            // Store a reference to the BuildContext to check if mounted later
            final currentContext = context;

            // Use Future.microtask to change theme after the current build cycle
            // This prevents the widget from being disposed during theme change
            Future.microtask(() {
              // Check if the widget is still mounted before using BuildContext
              if (!currentContext.mounted) return;

              if (state.isSystemTheme) {
                // If system theme is on, switch to explicit light or dark based on current state
                currentContext.read<ThemeBloc>().add(
                  ThemeChanged(isDarkMode: !isDarkMode),
                );
              } else {
                // If already in explicit mode, just toggle
                currentContext.read<ThemeBloc>().add(
                  ThemeChanged(isDarkMode: !state.isDarkMode!),
                );
              }

              // Ensure language stays the same after theme change
              // This prevents the language from resetting to English
              if (currentLanguage != localizationBloc.currentLanguageCode) {
                Future.microtask(() {
                  // Check if the widget is still mounted before using BuildContext
                  if (!currentContext.mounted) return;

                  localizationBloc.add(
                    LocaleChanged(languageCode: currentLanguage),
                  );
                });
              }
            });
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
