import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../blocs/localization/localization_bloc.dart';
import '../blocs/localization/localization_event.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import '../config/app_config.dart';
import '../i18n/app_localizations.dart';
import '../themes/app_gradients.dart';
import '../themes/universal_constants.dart';
import '../ui/cards/glass_card.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.translate('settings')),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.accentVertical(isDark: false),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(UniversalConstants.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App Preferences',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                              child: const Text(
                                'Theme',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
                              title: const Text('System Theme'),
                              subtitle: const Text('Follow device settings'),
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
                              title: const Text('Light Theme'),
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
                              title: const Text('Dark Theme'),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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
                          title: const Text('English'),
                          onTap: () {
                            context.read<LocalizationBloc>().add(
                              LocaleChanged(languageCode: 'en'),
                            );
                          },
                          trailing:
                              i18n.locale.languageCode == 'en'
                                  ? const Icon(
                                    LineIcons.check,
                                    color: Colors.green,
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
                          title: const Text('العربية'),
                          onTap: () {
                            context.read<LocalizationBloc>().add(
                              LocaleChanged(languageCode: 'ar'),
                            );
                          },
                          trailing:
                              i18n.locale.languageCode == 'ar'
                                  ? const Icon(
                                    LineIcons.check,
                                    color: Colors.green,
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
                        const Padding(
                          padding: EdgeInsets.all(
                            UniversalConstants.spacingMedium,
                          ),
                          child: Text(
                            'About',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const Divider(height: 1),

                        const ListTile(
                          leading: Icon(LineIcons.info),
                          title: Text('App Version'),
                          subtitle: Text('1.0.0'),
                        ),

                        ListTile(
                          leading: const Icon(LineIcons.alternateShield),
                          title: const Text('Privacy Policy'),
                          trailing: const Icon(LineIcons.angleRight),
                          onTap: () {
                            // Open privacy policy
                          },
                        ),

                        ListTile(
                          leading: const Icon(LineIcons.fileAlt),
                          title: const Text('Terms of Service'),
                          trailing: const Icon(LineIcons.angleRight),
                          onTap: () {
                            // Open terms of service
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: UniversalConstants.spacingMedium),

                  // App Info
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          AppConfig.appName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: UniversalConstants.spacingSmall),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(color: Colors.white70),
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
