import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../blocs/auth/app_auth_bloc.dart';
import '../../blocs/auth/app_auth_state.dart';
import '../../i18n/app_localizations.dart';
import '../../models/user_model.dart';
import '../../themes/app_text_styles.dart';
import '../../ui/app_bar/custom_app_bar.dart';
import '../../ui/buttons/primary_button.dart';
import '../../ui/inputs/custom_text_field.dart';
import '../../utils/toast_util.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  UserModel? _userModel;
  bool _passwordChangeMode = false;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authBloc = context.read<AppAuthBloc>();
    final state = authBloc.state;
    if (state is AuthAuthenticated) {
      setState(() {
        _userModel = UserModel.fromSupabaseUser(state.user);
        _displayNameController.text = _userModel?.displayName ?? '';
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (!mounted) return;
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final supabase = context.read<AppAuthBloc>().supabase;

        // Update the user metadata with the new display name
        await supabase.auth.updateUser(
          UserAttributes(data: {'name': _displayNameController.text.trim()}),
        );

        // Refresh the user data after update
        if (mounted) _loadUserData();

        if (mounted) {
          ToastUtil.showSuccess(context, 'Profile updated successfully');
        }
      } catch (e) {
        if (mounted) {
          ToastUtil.showError(context, 'Failed to update profile: $e');
        }
      }
    }
  }

  Future<void> _changePassword() async {
    if (!mounted) return;
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (_newPasswordController.text != _confirmPasswordController.text) {
          ToastUtil.showError(context, 'Passwords do not match');
          return;
        }

        final supabase = context.read<AppAuthBloc>().supabase;

        // Update the user's password
        await supabase.auth.updateUser(
          UserAttributes(password: _newPasswordController.text),
        );

        // Clear the password fields
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        // Exit password change mode
        setState(() {
          _passwordChangeMode = false;
        });

        if (mounted) {
          ToastUtil.showSuccess(context, 'Password updated successfully');
        }
      } catch (e) {
        if (mounted) {
          ToastUtil.showError(context, 'Failed to update password: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final locale = i18n.locale;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: i18n.translate('profile'),
        centerTitle: false,
      ),
      body: BlocListener<AppAuthBloc, AppAuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _loadUserData();
          } else if (state is AuthError) {
            ToastUtil.showError(context, state.message);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User profile header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: theme.colorScheme.secondary,
                          child: Text(
                            _userModel?.displayName?.isNotEmpty == true
                                ? _userModel!.displayName![0].toUpperCase()
                                : _userModel?.email[0].toUpperCase() ?? '?',
                            style:
                                isDark
                                    ? AppTextStyles.headingLargeDark(
                                      locale: locale,
                                    )
                                    : AppTextStyles.headingLargeLight(
                                      locale: locale,
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _userModel?.email ?? '',
                          style:
                              isDark
                                  ? AppTextStyles.bodyMediumDark(locale: locale)
                                  : AppTextStyles.bodyMediumLight(
                                    locale: locale,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Profile fields
                  Text(
                    'Personal Information',
                    style:
                        isDark
                            ? AppTextStyles.headingMediumDark(locale: locale)
                            : AppTextStyles.headingMediumLight(locale: locale),
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: i18n.translate('full_name'),
                    hint: i18n.translate('full_name_hint'),
                    controller: _displayNameController,
                    prefixIcon: Icon(LineIcons.user),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Password management section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Password Management',
                        style:
                            isDark
                                ? AppTextStyles.headingMediumDark(
                                  locale: locale,
                                )
                                : AppTextStyles.headingMediumLight(
                                  locale: locale,
                                ),
                      ),
                      TextButton.icon(
                        icon: Icon(
                          _passwordChangeMode
                              ? LineIcons.minus
                              : LineIcons.plus,
                          color: theme.colorScheme.primary,
                        ),
                        label: Text(
                          _passwordChangeMode ? 'Cancel' : 'Change Password',
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordChangeMode = !_passwordChangeMode;
                          });
                        },
                      ),
                    ],
                  ),

                  if (_passwordChangeMode) ...[
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Current Password',
                      hint: '••••••••',
                      controller: _currentPasswordController,
                      prefixIcon: Icon(LineIcons.lock),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'New Password',
                      hint: '••••••••',
                      controller: _newPasswordController,
                      prefixIcon: Icon(LineIcons.lock),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Confirm New Password',
                      hint: '••••••••',
                      controller: _confirmPasswordController,
                      prefixIcon: Icon(LineIcons.lock),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Update Password',
                        onPressed: _changePassword,
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Save button
                  if (!_passwordChangeMode)
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Save Changes',
                        onPressed: _updateUserProfile,
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
