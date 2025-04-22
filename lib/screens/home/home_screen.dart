import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../../blocs/auth/app_auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../i18n/app_localizations.dart';
import '../../themes/universal_constants.dart';
import '../../ui/app_bar/custom_app_bar.dart';
import '../../ui/buttons/primary_button.dart';
import '../../ui/cards/glass_card.dart';
import '../auth/login_screen.dart';
import '../../utils/toast_util.dart';

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
    final i18n = AppLocalizations.of(context);

    return BlocListener<AppAuthBloc, AuthState>(
      listener: (context, state) {
        // Listen for authentication state changes
        if (state is AuthUnauthenticated) {
          // Navigate to login screen when the user logs out
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else if (state is AuthError) {
          ToastUtil.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(title: i18n.translate('home'), centerTitle: false),
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
                      Icon(
                        LineIcons.user,
                        size: 48,
                        color: theme.iconTheme.color,
                      ),
                      const SizedBox(height: UniversalConstants.spacingMedium),
                      Text(
                        i18n.translateWithArgs('welcome_message', {
                          'name': user?.email?.split('@').first ?? 'User',
                        }),
                        style: theme.textTheme.titleLarge?.copyWith(
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
                      title: i18n.translate('flutter_starter_template'),
                      description: i18n.translate('template_description'),
                    ),
                    const SizedBox(height: UniversalConstants.spacingMedium),
                    _buildInfoCard(
                      context,
                      icon: LineIcons.alternateShield,
                      title: i18n.translate('authentication_ready'),
                      description: i18n.translate('auth_description'),
                    ),
                    const SizedBox(height: UniversalConstants.spacingMedium),
                    _buildInfoCard(
                      context,
                      icon: LineIcons.paintBrush,
                      title: i18n.translate('beautiful_ui'),
                      description: i18n.translate('ui_description'),
                    ),
                  ],
                ),
              ),

              // Logout button at the bottom
              PrimaryButton(
                text: i18n.translate('logout'),
                onPressed: () {
                  context.read<AppAuthBloc>().add(AuthLogoutRequested());
                },
              ),
            ],
          ),
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
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(
                  UniversalConstants.borderRadiusMedium,
                ),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: UniversalConstants.spacingXSmall),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
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
}
