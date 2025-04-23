import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../../blocs/auth/app_auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/routes.dart';
import '../../i18n/app_localizations.dart';
import '../../themes/app_text_styles.dart';
import '../../ui/app_bar/custom_app_bar.dart';
import '../../utils/toast_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);
    final locale = i18n.locale;
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AppAuthBloc, AuthState>(
      listener: (context, state) {
        // Listen for authentication state changes
        if (state is AuthUnauthenticated) {
          // Navigate to login screen when the user logs out
          AppRoutes.navigateAndRemoveUntil(context, AppRoutes.login);
        } else if (state is AuthError) {
          ToastUtil.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: i18n.translate('home'),
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(LineIcons.cog),
              onPressed:
                  () => AppRoutes.navigateTo(context, AppRoutes.settings),
              tooltip: i18n.translate('settings'),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                i18n.translate('welcome_message').replaceAll('{name}', 'User'),
                style:
                    isDark
                        ? AppTextStyles.bodyLargeDark(locale: locale)
                        : AppTextStyles.bodyLargeLight(locale: locale),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                i18n.translate('template_description'),
                style:
                    isDark
                        ? AppTextStyles.bodyMediumDark(locale: locale)
                        : AppTextStyles.bodyMediumLight(locale: locale),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
