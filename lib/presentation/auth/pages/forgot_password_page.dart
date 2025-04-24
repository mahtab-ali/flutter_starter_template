import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:starter_template_flutter/config/localization/app_localizations.dart';
import 'package:starter_template_flutter/presentation/auth/bloc/app_auth_state.dart';
import 'package:starter_template_flutter/presentation/auth/widgets/auth_header.dart';
import 'package:starter_template_flutter/presentation/auth/widgets/forgot_password_form.dart';
import 'package:starter_template_flutter/presentation/auth/widgets/password_reset_success.dart';
import 'package:starter_template_flutter/presentation/common/widgets/app_bar/custom_app_bar.dart';
import 'package:starter_template_flutter/presentation/common/widgets/cards/app_card.dart';

import '../../../core/constants/universal_constants.dart';
import '../../../core/utils/keyboard_util.dart';
import '../../../core/utils/toast_util.dart';
import '../bloc/app_auth_bloc.dart';
import '../bloc/app_auth_event.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  void _resetPassword(String email) {
    // Hide keyboard when submitting the form
    KeyboardUtil.hideKeyboard(context);

    if (_formKey.currentState?.validate() ?? false) {
      // Use AppAuthBloc with AuthResetPasswordRequested event
      context.read<AppAuthBloc>().add(AuthResetPasswordRequested(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final i18n = AppLocalizations.of(context);

    return BlocConsumer<AppAuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetFailure) {
          ToastUtil.showError(context, state.error);
        } else if (state is AuthPasswordResetSuccess) {
          ToastUtil.showSuccess(
            context,
            i18n.translate("reset_password_success_title"),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;
        final bool resetSent = state is AuthPasswordResetSuccess;

        return GestureDetector(
          // Add tap listener to dismiss keyboard when tapping outside
          onTap: () => KeyboardUtil.hideKeyboard(context),
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: CustomAppBar(
              title: i18n.translate("forgot_password"),
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
                          // Auth Header with Key Icon
                          AuthHeader(icon: LineIcons.key),

                          // Main Content Card
                          AppCard(
                            elevation: 4.0,
                            padding: const EdgeInsets.all(
                              UniversalConstants.spacingLarge,
                            ),
                            child:
                                !resetSent
                                    ? ForgotPasswordForm(
                                      isLoading: isLoading,
                                      onSubmit: _resetPassword,
                                    )
                                    : PasswordResetSuccess(
                                      email: state.email,
                                      onBackToLogin:
                                          () => Navigator.pop(context),
                                    ),
                          ),
                          const SizedBox(
                            height: UniversalConstants.spacingMedium,
                          ),

                          // Back to login link (only show if not in success state)
                          if (!resetSent)
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.primary,
                                ),
                                child: Text(
                                  i18n.translate("back_to_login"),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
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
