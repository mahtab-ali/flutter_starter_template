import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../../blocs/localization/localization_bloc.dart';
import '../../blocs/localization/localization_event.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../blocs/theme/theme_event.dart';
import '../../blocs/theme/theme_state.dart';
import '../../config/app_config.dart';
import '../../i18n/app_localizations.dart';
import '../../themes/app_gradients.dart';
import '../../themes/universal_constants.dart';
import '../../ui/cards/glass_card.dart';
import '../../widgets/app_bar_actions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.translate('settings')),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: const [AppBarActions()],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.accentVertical(isDark: isDark),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(UniversalConstants.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Preferences',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: UniversalConstants.spacingLarge),

                  // Theme Toggle Card
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, themeState) {
                      // Display the theme options in different ways depending on mode
                      return GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(
                                UniversalConstants.spacingMedium,
                              ),
                              child: Text(
                                'Theme',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Divider(height: 1),

                            // System Theme Option
                            ListTile(
                              leading: Icon(
                                LineIcons.desktop,
                                color:
                                    themeState.isSystemTheme
                                        ? theme.colorScheme.primary
                                        : null,
                              ),
                              title: Text(
                                'System Theme',
                                style: theme.textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                'Follow device settings',
                                style: theme.textTheme.bodySmall,
                              ),
                              selected: themeState.isSystemTheme,
                              onTap: () {
                                context.read<ThemeBloc>().add(UseSystemTheme());
                              },
                              trailing:
                                  themeState.isSystemTheme
                                      ? Icon(
                                        LineIcons.check,
                                        color: theme.colorScheme.primary,
                                      )
                                      : null,
                            ),

                            // Light Theme Option
                            ListTile(
                              leading: Icon(
                                LineIcons.sun,
                                color:
                                    !themeState.isSystemTheme &&
                                            themeState.isDarkMode == false
                                        ? theme.colorScheme.primary
                                        : null,
                              ),
                              title: Text(
                                'Light Theme',
                                style: theme.textTheme.bodyLarge,
                              ),
                              onTap: () {
                                context.read<ThemeBloc>().add(
                                  ThemeChanged(isDarkMode: false),
                                );
                              },
                              trailing:
                                  !themeState.isSystemTheme &&
                                          themeState.isDarkMode == false
                                      ? Icon(
                                        LineIcons.check,
                                        color: theme.colorScheme.primary,
                                      )
                                      : null,
                            ),

                            // Dark Theme Option
                            ListTile(
                              leading: Icon(
                                LineIcons.moon,
                                color:
                                    !themeState.isSystemTheme &&
                                            themeState.isDarkMode == true
                                        ? theme.colorScheme.primary
                                        : null,
                              ),
                              title: Text(
                                'Dark Theme',
                                style: theme.textTheme.bodyLarge,
                              ),
                              onTap: () {
                                context.read<ThemeBloc>().add(
                                  ThemeChanged(isDarkMode: true),
                                );
                              },
                              trailing:
                                  !themeState.isSystemTheme &&
                                          themeState.isDarkMode == true
                                      ? Icon(
                                        LineIcons.check,
                                        color: theme.colorScheme.primary,
                                      )
                                      : null,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: UniversalConstants.spacingMedium),

                  // Language Selector Card
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                            UniversalConstants.spacingMedium,
                          ),
                          child: Text(
                            i18n.translate('select_language'),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(height: 1),

                        // English Option
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://flagcdn.com/w80/us.png',
                            ),
                          ),
                          title: Text(
                            'English',
                            style: theme.textTheme.bodyLarge,
                          ),
                          onTap: () {
                            context.read<LocalizationBloc>().add(
                              LocaleChanged(languageCode: 'en'),
                            );
                          },
                          trailing:
                              i18n.locale.languageCode == 'en'
                                  ? Icon(
                                    LineIcons.check,
                                    color: theme.colorScheme.primary,
                                  )
                                  : null,
                        ),

                        // Arabic Option
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://flagcdn.com/w80/sa.png',
                            ),
                          ),
                          title: Text(
                            'العربية',
                            style: theme.textTheme.bodyLarge,
                          ),
                          onTap: () {
                            context.read<LocalizationBloc>().add(
                              LocaleChanged(languageCode: 'ar'),
                            );
                          },
                          trailing:
                              i18n.locale.languageCode == 'ar'
                                  ? Icon(
                                    LineIcons.check,
                                    color: theme.colorScheme.primary,
                                  )
                                  : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: UniversalConstants.spacingMedium),

                  // About Card
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                            UniversalConstants.spacingMedium,
                          ),
                          child: Text(
                            'About',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(height: 1),

                        ListTile(
                          leading: Icon(
                            LineIcons.info,
                            color: theme.iconTheme.color,
                          ),
                          title: Text(
                            'App Version',
                            style: theme.textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                            '1.0.0',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),

                        ListTile(
                          leading: Icon(
                            LineIcons.alternateShield,
                            color: theme.iconTheme.color,
                          ),
                          title: Text(
                            'Privacy Policy',
                            style: theme.textTheme.bodyLarge,
                          ),
                          trailing: Icon(
                            LineIcons.angleRight,
                            color: theme.iconTheme.color,
                          ),
                          onTap: () {
                            // Open privacy policy
                          },
                        ),

                        ListTile(
                          leading: Icon(
                            LineIcons.fileAlt,
                            color: theme.iconTheme.color,
                          ),
                          title: Text(
                            'Terms of Service',
                            style: theme.textTheme.bodyLarge,
                          ),
                          trailing: Icon(
                            LineIcons.angleRight,
                            color: theme.iconTheme.color,
                          ),
                          onTap: () {
                            // Open terms of service
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: UniversalConstants.spacingMedium),

                  // App Info
                  Center(
                    child: Column(
                      children: [
                        Text(
                          AppConfig.appName,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(height: UniversalConstants.spacingSmall),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: theme.colorScheme.onBackground.withOpacity(
                              0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
