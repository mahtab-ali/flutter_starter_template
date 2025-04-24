import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:starter_template_flutter/config/localization/app_localizations.dart';
import 'package:starter_template_flutter/config/routes.dart';
import 'package:starter_template_flutter/core/utils/toast_util.dart';
import 'package:starter_template_flutter/data/models/response/user_model.dart';
import 'package:starter_template_flutter/presentation/auth/bloc/app_auth_bloc.dart';
import 'package:starter_template_flutter/presentation/auth/bloc/app_auth_state.dart';
import 'package:starter_template_flutter/presentation/home/widgets/home_description_section.dart';
import 'package:starter_template_flutter/presentation/home/widgets/home_welcome_section.dart';

import '../../../presentation/common/widgets/app_bar/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? _userModel;
  String _displayName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authBloc = context.read<AppAuthBloc>();
    final state = authBloc.state;
    if (state is AuthAuthenticated) {
      setState(() {
        _userModel = UserModel.fromUserEntity(state.user);
        _displayName =
            _userModel?.displayName ??
            _userModel?.email.split('@').first ??
            'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);

    return BlocListener<AppAuthBloc, AppAuthState>(
      listener: (context, state) {
        // Listen for authentication state changes
        if (state is AuthAuthenticated) {
          _loadUserData(); // Reload user data whenever auth state changes
        } else if (state is AuthUnauthenticated) {
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
              icon: const Icon(LineIcons.user),
              onPressed: () => AppRoutes.navigateTo(context, AppRoutes.profile),
              tooltip: i18n.translate('profile'),
            ),
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
              HomeWelcomeSection(displayName: _displayName),
              const SizedBox(height: 24),
              const HomeDescriptionSection(),
            ],
          ),
        ),
      ),
    );
  }
}
