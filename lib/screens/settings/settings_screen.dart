import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../../blocs/app/app_bloc.dart';
import '../../blocs/app/app_state.dart';
import '../../blocs/auth/app_auth_bloc.dart';
import '../../blocs/auth/app_auth_event.dart';
import '../../blocs/localization/localization_bloc.dart';
import '../../blocs/localization/localization_event.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../blocs/theme/theme_event.dart';
import '../../blocs/theme/theme_state.dart';
import '../../config/app_config.dart';
import '../../config/routes.dart';
import '../../i18n/app_localizations.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/universal_constants.dart';
import '../../ui/app_bar/custom_app_bar.dart';
import '../../ui/cards/app_card.dart';
import '../../ui/dialogs/custom_alert_dialog.dart';
import '../../utils/helper.dart';
import '../../utils/toast_util.dart';

// Changed to StatelessWidget since it doesn't maintain any internal state
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);
    final locale = i18n.locale;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: i18n.translate('settings'),
        centerTitle: false,
        hideActions: true, // Hide the app bar actions on settings screen
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(UniversalConstants.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  i18n.translate('app_preferences'),
                  style:
                      isDark
                          ? AppTextStyles.headingSmallDark(
                            locale: locale,
                          ).copyWith(fontWeight: FontWeight.bold)
                          : AppTextStyles.headingSmallLight(
                            locale: locale,
                          ).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: UniversalConstants.spacingLarge),

                // Theme Toggle Card
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    // Display the theme options in different ways depending on mode
                    return _buildCard(
                      context,
                      title: i18n.translate('theme'),
                      children: [
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
                            i18n.translate('light_theme'),
                            style:
                                isDark
                                    ? AppTextStyles.bodyLargeDark(
                                      locale: locale,
                                    )
                                    : AppTextStyles.bodyLargeLight(
                                      locale: locale,
                                    ),
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
                            i18n.translate('dark_theme'),
                            style:
                                isDark
                                    ? AppTextStyles.bodyLargeDark(
                                      locale: locale,
                                    )
                                    : AppTextStyles.bodyLargeLight(
                                      locale: locale,
                                    ),
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
                    );
                  },
                ),
                const SizedBox(height: UniversalConstants.spacingMedium),

                // Language Selector Card
                _buildCard(
                  context,
                  title: i18n.translate('select_language'),
                  children: [
                    // English Option
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://flagcdn.com/w80/us.png',
                        ),
                      ),
                      title: Text(
                        i18n.translate('english'),
                        style:
                            isDark
                                ? AppTextStyles.bodyLargeDark(locale: locale)
                                : AppTextStyles.bodyLargeLight(locale: locale),
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
                        i18n.translate('arabic'),
                        style:
                            isDark
                                ? AppTextStyles.bodyLargeDark(locale: locale)
                                : AppTextStyles.bodyLargeLight(locale: locale),
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
                const SizedBox(height: UniversalConstants.spacingMedium),

                // About Card with App Version
                BlocBuilder<AppBloc, AppState>(
                  builder: (context, appState) {
                    return _buildCard(
                      context,
                      title: i18n.translate('about'),
                      children: [
                        ListTile(
                          leading: Icon(
                            LineIcons.info,
                            color: theme.iconTheme.color,
                          ),
                          title: Text(
                            i18n.translate('app_version'),
                            style:
                                isDark
                                    ? AppTextStyles.bodyLargeDark(
                                      locale: locale,
                                    )
                                    : AppTextStyles.bodyLargeLight(
                                      locale: locale,
                                    ),
                          ),
                          subtitle: Text(
                            appState.fullAppVersion,
                            style:
                                isDark
                                    ? AppTextStyles.bodySmallDark(
                                      locale: locale,
                                    )
                                    : AppTextStyles.bodySmallLight(
                                      locale: locale,
                                    ),
                          ),
                        ),

                        // Device Info
                        ListTile(
                          leading: Icon(
                            LineIcons.mobilePhone,
                            color: theme.iconTheme.color,
                          ),
                          title: Text(
                            i18n.translate('device_info'),
                            style:
                                isDark
                                    ? AppTextStyles.bodyLargeDark(
                                      locale: locale,
                                    )
                                    : AppTextStyles.bodyLargeLight(
                                      locale: locale,
                                    ),
                          ),
                          subtitle: Text(
                            appState.deviceInfo,
                            style:
                                isDark
                                    ? AppTextStyles.bodySmallDark(
                                      locale: locale,
                                    )
                                    : AppTextStyles.bodySmallLight(
                                      locale: locale,
                                    ),
                          ),
                        ),

                        ListTile(
                          leading: Icon(
                            LineIcons.alternateShield,
                            color: theme.iconTheme.color,
                          ),
                          title: Text(
                            i18n.translate('privacy_policy'),
                            style:
                                isDark
                                    ? AppTextStyles.bodyLargeDark(
                                      locale: locale,
                                    )
                                    : AppTextStyles.bodyLargeLight(
                                      locale: locale,
                                    ),
                          ),
                          trailing: Icon(
                            Helper.getDirectionalIcon(
                              context,
                              LineIcons.angleRight,
                              LineIcons.angleLeft,
                            ),
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
                            i18n.translate('terms_of_service'),
                            style:
                                isDark
                                    ? AppTextStyles.bodyLargeDark(
                                      locale: locale,
                                    )
                                    : AppTextStyles.bodyLargeLight(
                                      locale: locale,
                                    ),
                          ),
                          trailing: Icon(
                            Helper.getDirectionalIcon(
                              context,
                              LineIcons.angleRight,
                              LineIcons.angleLeft,
                            ),
                            color: theme.iconTheme.color,
                          ),
                          onTap: () {
                            // Open terms of service
                          },
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: UniversalConstants.spacingMedium),

                // Logout Card - Moved to the end
                _buildCard(
                  context,
                  title: i18n.translate('account'),
                  children: [
                    ListTile(
                      leading: Icon(
                        LineIcons.alternateSignOut,
                        color: theme.colorScheme.error,
                      ),
                      title: Text(
                        i18n.translate('logout'),
                        style:
                            isDark
                                ? AppTextStyles.bodyLargeDark(
                                  locale: locale,
                                ).copyWith(color: theme.colorScheme.error)
                                : AppTextStyles.bodyLargeLight(
                                  locale: locale,
                                ).copyWith(color: theme.colorScheme.error),
                      ),
                      onTap: () {
                        _showLogoutConfirmationDialog(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: UniversalConstants.spacingLarge),

                // App Info
                Center(
                  child: Column(
                    children: [
                      Text(
                        AppConfig.appName,
                        style:
                            isDark
                                ? AppTextStyles.bodyLargeDark(
                                  locale: locale,
                                ).copyWith(fontWeight: FontWeight.bold)
                                : AppTextStyles.bodyLargeLight(
                                  locale: locale,
                                ).copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: UniversalConstants.spacingSmall),
                      BlocBuilder<AppBloc, AppState>(
                        builder: (context, appState) {
                          return Text(
                            i18n.translateWithArgs('version', {
                              'version': appState.fullAppVersion,
                            }),
                            style:
                                isDark
                                    ? AppTextStyles.bodySmallDark(
                                      locale: locale,
                                    ).copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(180),
                                    )
                                    : AppTextStyles.bodySmallLight(
                                      locale: locale,
                                    ).copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(180),
                                    ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build card with consistent styling
  Widget _buildCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = AppLocalizations.of(context).locale;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(UniversalConstants.spacingMedium),
            child: Text(
              title,
              style:
                  isDark
                      ? AppTextStyles.bodyLargeDark(
                        locale: locale,
                      ).copyWith(fontWeight: FontWeight.bold)
                      : AppTextStyles.bodyLargeLight(
                        locale: locale,
                      ).copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor.withAlpha(20)),
          ...children,
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final i18n = AppLocalizations.of(context);

    CustomAlertDialog.showConfirmation(
      context,
      title: i18n.translate('logout_confirmation'),
      message: i18n.translate('logout_confirmation_message'),
      onConfirm: () {
        // Perform logout action
        context.read<AppAuthBloc>().add(AuthLogoutRequested());
        // Show success message
        ToastUtil.showSuccess(
          context,
          i18n.translate('logged_out_successfully'),
        );
        // Navigate to login screen
        AppRoutes.navigateAndRemoveUntil(context, AppRoutes.login);
      },
      confirmText: i18n.translate('logout'),
      cancelText: i18n.translate('cancel'),
    );
  }
}
