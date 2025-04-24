import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:starter_template_flutter/config/localization/app_localizations.dart';
import 'package:starter_template_flutter/config/routes.dart';
import 'package:starter_template_flutter/presentation/auth/bloc/app_auth_bloc.dart';
import 'package:starter_template_flutter/presentation/auth/bloc/app_auth_event.dart';
import 'package:starter_template_flutter/presentation/auth/bloc/app_auth_state.dart';
import 'package:starter_template_flutter/presentation/auth/widgets/auth_footer.dart';
import 'package:starter_template_flutter/presentation/auth/widgets/auth_header.dart';
import 'package:starter_template_flutter/presentation/auth/widgets/register_form.dart';
import 'package:starter_template_flutter/presentation/common/widgets/app_bar/custom_app_bar.dart';
import 'package:starter_template_flutter/presentation/common/widgets/cards/app_card.dart';

import '../../../core/constants/universal_constants.dart';
import '../../../core/utils/keyboard_util.dart';
import '../../../core/utils/toast_util.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  void _register(String name, String email, String password) {
    // Hide keyboard when submitting the form
    KeyboardUtil.hideKeyboard(context);

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AppAuthBloc>().add(
        AuthRegisterRequested(name: name, email: email, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);

    return BlocConsumer<AppAuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ToastUtil.showError(context, state.message);
        } else if (state is AuthAuthenticated) {
          ToastUtil.showSuccess(
            context,
            i18n.translate('registration_successful'),
          );
          // Navigate to home screen after successful registration
          AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;

        return GestureDetector(
          // Add tap listener to dismiss keyboard when tapping outside
          onTap: () => KeyboardUtil.hideKeyboard(context),
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: CustomAppBar(
              title: i18n.translate('register'),
              centerTitle: false,
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      UniversalConstants.spacingLarge,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Auth Header with Icon
                          AuthHeader(icon: LineIcons.userPlus),

                          // Form Container
                          AppCard(
                            elevation: 4.0,
                            padding: const EdgeInsets.all(
                              UniversalConstants.spacingLarge,
                            ),
                            child: RegisterForm(
                              isLoading: isLoading,
                              onSubmit: _register,
                            ),
                          ),
                          const SizedBox(
                            height: UniversalConstants.spacingLarge,
                          ),

                          // Login Link
                          AuthFooter(
                            messageText: i18n.translate('already_have_account'),
                            actionText: i18n.translate('login'),
                            onActionPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
