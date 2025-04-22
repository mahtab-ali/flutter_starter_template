import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../blocs/auth/app_auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/localization/localization_bloc.dart';
import '../blocs/localization/localization_event.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import '../i18n/app_localizations.dart';
import '../themes/app_colors.dart';
import '../themes/universal_constants.dart';
import '../ui/bottom_sheets/ios_bottom_sheet.dart';
import '../ui/buttons/primary_button.dart';
import '../ui/cards/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthBloc>();
    final user =
        (auth.state is AuthAuthenticated)
            ? (auth.state as AuthAuthenticated).user
            : null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('home')),
        actions: [
          IconButton(
            icon: const Icon(LineIcons.cog),
            onPressed: () => _showSettingsSheet(context),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(UniversalConstants.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: UniversalConstants.spacingMedium),

            // User welcome card with glass effect
            GlassCard(
              height: 150,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LineIcons.user, size: 48),
                    const SizedBox(height: UniversalConstants.spacingMedium),
                    Text(
                      AppLocalizations.of(context).translateWithArgs(
                        'welcome_message',
                        {'name': user?.email?.split('@').first ?? 'User'},
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: UniversalConstants.spacingXLarge),

            // Content cards
            Expanded(
              child: ListView(
                children: [
                  _buildInfoCard(
                    context,
                    icon: LineIcons.infoCircle,
                    title: 'Flutter Starter Template',
                    description:
                        'A template with authentication, theme switching, and localization.',
                  ),
                  const SizedBox(height: UniversalConstants.spacingMedium),
                  _buildInfoCard(
                    context,
                    icon: LineIcons.alternateShield,
                    title: 'Authentication Ready',
                    description:
                        'Integrated with Supabase for secure user authentication.',
                  ),
                  const SizedBox(height: UniversalConstants.spacingMedium),
                  _buildInfoCard(
                    context,
                    icon: LineIcons.paintBrush,
                    title: 'Beautiful UI Components',
                    description:
                        'Pre-styled components with frosted glass effects and gradients.',
                  ),
                ],
              ),
            ),

            // Logout button at the bottom
            PrimaryButton(
              text: AppLocalizations.of(context).translate('logout'),
              onPressed: () {
                context.read<AppAuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          UniversalConstants.borderRadiusLarge,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UniversalConstants.spacingMedium),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(UniversalConstants.spacingMedium),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.primaryDark.withOpacity(0.2)
                        : AppColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  UniversalConstants.borderRadiusMedium,
                ),
              ),
              child: Icon(
                icon,
                color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                size: UniversalConstants.iconSizeLarge,
              ),
            ),
            const SizedBox(width: UniversalConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: UniversalConstants.spacingXSmall),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showIosBottomSheet(
      context: context,
      child: IosBottomSheetContent(
        title: AppLocalizations.of(context).translate('settings'),
        icon: const Icon(LineIcons.cog),
        child: Column(
          children: [
            _buildThemeToggle(context),
            const Divider(height: UniversalConstants.spacingLarge),
            _buildLanguageSelector(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        // Create theme selection cards
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: UniversalConstants.spacingMedium,
                bottom: UniversalConstants.spacingSmall,
              ),
              child: Text(
                "Theme",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // System Theme option
            ListTile(
              leading: Icon(
                LineIcons.desktop,
                color:
                    state.isSystemTheme ? Theme.of(context).primaryColor : null,
              ),
              title: Text("Use System Theme"),
              subtitle: Text("Follow device settings"),
              selected: state.isSystemTheme,
              onTap: () {
                context.read<ThemeBloc>().add(UseSystemTheme());
                Navigator.pop(context);
              },
            ),

            // Light Theme option
            ListTile(
              leading: Icon(
                LineIcons.sun,
                color:
                    !state.isSystemTheme && state.isDarkMode == false
                        ? Theme.of(context).primaryColor
                        : null,
              ),
              title: Text("Light Mode"),
              selected: !state.isSystemTheme && state.isDarkMode == false,
              onTap: () {
                context.read<ThemeBloc>().add(ThemeChanged(isDarkMode: false));
                Navigator.pop(context);
              },
            ),

            // Dark Theme option
            ListTile(
              leading: Icon(
                LineIcons.moon,
                color:
                    !state.isSystemTheme && state.isDarkMode == true
                        ? Theme.of(context).primaryColor
                        : null,
              ),
              title: Text("Dark Mode"),
              selected: !state.isSystemTheme && state.isDarkMode == true,
              onTap: () {
                context.read<ThemeBloc>().add(ThemeChanged(isDarkMode: true));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: UniversalConstants.spacingMedium,
            bottom: UniversalConstants.spacingSmall,
          ),
          child: Text(
            AppLocalizations.of(context).translate('language'),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Text('🇺🇸'),
          title: Text(AppLocalizations.of(context).translate('english')),
          onTap: () {
            context.read<LocalizationBloc>().add(
              LocaleChanged(languageCode: 'en'),
            );
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Text('🇸🇦'),
          title: Text(AppLocalizations.of(context).translate('arabic')),
          onTap: () {
            context.read<LocalizationBloc>().add(
              LocaleChanged(languageCode: 'ar'),
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
