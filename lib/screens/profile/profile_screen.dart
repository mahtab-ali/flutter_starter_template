import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:starter_template_flutter/widgets/app_bar_actions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../blocs/auth/app_auth_bloc.dart';
import '../../blocs/auth/app_auth_event.dart';
import '../../blocs/auth/app_auth_state.dart';
import '../../i18n/app_localizations.dart';
import '../../models/user_model.dart';
import '../../themes/app_gradients.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/universal_constants.dart';
import '../../ui/app_bar/custom_app_bar.dart';
import '../../ui/buttons/primary_button.dart';
import '../../ui/cards/app_card.dart';
import '../../ui/dialogs/custom_alert_dialog.dart';
import '../../ui/inputs/custom_text_field.dart';
import '../../utils/helper.dart';
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
  bool _isLoading = false;

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
    try {
      setState(() => _isLoading = true);

      // Use the bloc to update user data
      final authBloc = context.read<AppAuthBloc>();
      authBloc.add(
        UpdateUserDataRequested(
          displayName: _displayNameController.text.trim(),
        ),
      );

      // We'll hide the dialog in the bloc listener
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ToastUtil.showError(context, 'Failed to update profile: $e');
      }
    }
  }

  Future<void> _changePassword() async {
    if (!mounted || !_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      if (_newPasswordController.text != _confirmPasswordController.text) {
        ToastUtil.showError(context, 'Passwords do not match');
        setState(() => _isLoading = false);
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

      setState(() => _isLoading = false);

      if (mounted) {
        ToastUtil.showSuccess(context, 'Password updated successfully');
        Navigator.of(context).pop(); // Close dialog
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ToastUtil.showError(context, 'Failed to update password: $e');
      }
    }
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final i18n = AppLocalizations.of(context);
        final locale = i18n.locale;
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              UniversalConstants.borderRadiusLarge,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(UniversalConstants.spacingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  i18n.translate('edit_profile'),
                  style:
                      isDark
                          ? AppTextStyles.headingSmallDark(locale: locale)
                          : AppTextStyles.headingSmallLight(locale: locale),
                ),
                const SizedBox(height: UniversalConstants.spacingMedium),
                CustomTextField(
                  label: i18n.translate('full_name'),
                  hint: i18n.translate('full_name_hint'),
                  controller: _displayNameController,
                  prefixIcon: Icon(LineIcons.userEdit),
                ),
                const SizedBox(height: UniversalConstants.spacingLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton.text(
                      text: i18n.translate('cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                      minWidth: 100,
                    ),
                    const SizedBox(width: UniversalConstants.spacingMedium),
                    PrimaryButton(
                      text: i18n.translate('save'),
                      onPressed: _isLoading ? null : _updateUserProfile,
                      isLoading: _isLoading,
                      minWidth: 100,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final i18n = AppLocalizations.of(context);
        final locale = i18n.locale;
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              UniversalConstants.borderRadiusLarge,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(UniversalConstants.spacingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    i18n.translate('change_password'),
                    style:
                        isDark
                            ? AppTextStyles.headingSmallDark(locale: locale)
                            : AppTextStyles.headingSmallLight(locale: locale),
                  ),
                  const SizedBox(height: UniversalConstants.spacingMedium),
                  CustomTextField(
                    label: i18n.translate('current_password'),
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
                  const SizedBox(height: UniversalConstants.spacingMedium),
                  CustomTextField(
                    label: i18n.translate('new_password'),
                    hint: '••••••••',
                    controller: _newPasswordController,
                    prefixIcon: Icon(LineIcons.key),
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
                  const SizedBox(height: UniversalConstants.spacingMedium),
                  CustomTextField(
                    label: i18n.translate('confirm_password'),
                    hint: '••••••••',
                    controller: _confirmPasswordController,
                    prefixIcon: Icon(LineIcons.lockOpen),
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
                  const SizedBox(height: UniversalConstants.spacingLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PrimaryButton.text(
                        text: i18n.translate('cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                        minWidth: 100,
                      ),
                      const SizedBox(width: UniversalConstants.spacingMedium),
                      PrimaryButton(
                        text: i18n.translate('update'),
                        onPressed: _isLoading ? null : _changePassword,
                        isLoading: _isLoading,
                        minWidth: 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPermissionsInfoDialog() {
    final i18n = AppLocalizations.of(context);

    CustomAlertDialog.showInfo(
      context,
      title: i18n.translate('permissions_info'),
      message: i18n.translate('permissions_description'),
      actions: [
        PrimaryButton(
          text: i18n.translate('ok'),
          minWidth: 120,
          onPressed: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(
            UniversalConstants.borderRadiusFull,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = AppLocalizations.of(context).locale;

    return AppCard(
      elevation: 1.0,
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

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final locale = i18n.locale;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    // Format user data for display
    final DateTime? lastLogin = _userModel?.lastLogin;
    final String lastLoginStr =
        lastLogin != null
            ? '${lastLogin.day}/${lastLogin.month}/${lastLogin.year}'
            : 'N/A';
    final String createdAt =
        _userModel?.createdAt != null
            ? '${_userModel!.createdAt!.day}/${_userModel!.createdAt!.month}/${_userModel!.createdAt!.year}'
            : 'N/A';

    // Get display name or empty string (not "user")
    final String displayName = _userModel?.displayName ?? '';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: i18n.translate('profile'),
        centerTitle: false,
        // Add app bar actions for theme and language
        actions: const [AppBarActions()],
      ),
      body: BlocListener<AppAuthBloc, AppAuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _loadUserData();
            // Close dialog if it was open (for profile update)
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
              ToastUtil.showSuccess(context, i18n.translate('success'));
            }
          } else if (state is AuthError) {
            ToastUtil.showError(context, state.message);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UniversalConstants.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with profile picture
                AppCard(
                  padding: EdgeInsets.zero,
                  gradient: AppGradients.primaryVertical(isDark: isDark),
                  child: Stack(
                    children: [
                      // Decorative background bubbles
                      Positioned(
                        top: -30,
                        right: -20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -25,
                        left: -25,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // Profile content centered with white text
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(
                          UniversalConstants.spacingLarge,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile picture
                            Hero(
                              tag: 'profile_avatar',
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(50),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    displayName.isNotEmpty
                                        ? displayName[0].toUpperCase()
                                        : _userModel?.email[0].toUpperCase() ??
                                            '?',
                                    style: AppTextStyles.headingLargeDark(
                                      locale: locale,
                                    ).copyWith(color: primaryColor),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: UniversalConstants.spacingMedium,
                            ),

                            // User name - white text on gradient
                            Text(
                              displayName.isNotEmpty
                                  ? displayName
                                  : i18n.translate('anonymous'),
                              style: AppTextStyles.headingMediumLight(
                                locale: locale,
                              ).copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: UniversalConstants.spacingXSmall,
                            ),

                            // Email - white text on gradient
                            Text(
                              _userModel?.email ?? '',
                              style: AppTextStyles.bodyMediumLight(
                                locale: locale,
                              ).copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: UniversalConstants.spacingMedium),

                // Account information section (removed account ID)
                _buildCard(
                  context,
                  title: i18n.translate('account_info'),
                  children: [
                    ListTile(
                      leading: Icon(LineIcons.calendar, color: primaryColor),
                      title: Text(
                        i18n.translate('account_created'),
                        style:
                            isDark
                                ? AppTextStyles.bodyMediumDark(locale: locale)
                                : AppTextStyles.bodyMediumLight(locale: locale),
                      ),
                      subtitle: Text(
                        createdAt,
                        style:
                            isDark
                                ? AppTextStyles.bodySmallDark(locale: locale)
                                : AppTextStyles.bodySmallLight(locale: locale),
                      ),
                    ),
                    ListTile(
                      leading: Icon(LineIcons.clock, color: primaryColor),
                      title: Text(
                        i18n.translate('last_login'),
                        style:
                            isDark
                                ? AppTextStyles.bodyMediumDark(locale: locale)
                                : AppTextStyles.bodyMediumLight(locale: locale),
                      ),
                      subtitle: Text(
                        lastLoginStr,
                        style:
                            isDark
                                ? AppTextStyles.bodySmallDark(locale: locale)
                                : AppTextStyles.bodySmallLight(locale: locale),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: UniversalConstants.spacingMedium),

                // Personal information section
                _buildCard(
                  context,
                  title: i18n.translate('personal_info'),
                  children: [
                    ListTile(
                      leading: Icon(LineIcons.userEdit, color: primaryColor),
                      title: Text(
                        i18n.translate('full_name'),
                        style:
                            isDark
                                ? AppTextStyles.bodyMediumDark(locale: locale)
                                : AppTextStyles.bodyMediumLight(locale: locale),
                      ),
                      subtitle: Text(
                        displayName.isNotEmpty
                            ? displayName
                            : i18n.translate('not_set'),
                        style:
                            isDark
                                ? AppTextStyles.bodySmallDark(locale: locale)
                                : AppTextStyles.bodySmallLight(locale: locale),
                      ),
                      trailing: Icon(
                        Helper.getDirectionalIcon(context, LineIcons.pen),
                        color: theme.colorScheme.primary,
                      ),
                      onTap: _showEditProfileDialog,
                    ),
                  ],
                ),

                const SizedBox(height: UniversalConstants.spacingMedium),

                // Security section
                _buildCard(
                  context,
                  title: i18n.translate('security'),
                  children: [
                    ListTile(
                      leading: Icon(LineIcons.lock, color: primaryColor),
                      title: Text(
                        i18n.translate('change_password'),
                        style:
                            isDark
                                ? AppTextStyles.bodyMediumDark(locale: locale)
                                : AppTextStyles.bodyMediumLight(locale: locale),
                      ),
                      trailing: Icon(
                        Helper.getDirectionalIcon(
                          context,
                          LineIcons.angleRight,
                          LineIcons.angleLeft,
                        ),
                        color: theme.iconTheme.color,
                      ),
                      onTap: _showChangePasswordDialog,
                    ),
                    ListTile(
                      leading: Icon(LineIcons.userShield, color: primaryColor),
                      title: Text(
                        i18n.translate('permissions'),
                        style:
                            isDark
                                ? AppTextStyles.bodyMediumDark(locale: locale)
                                : AppTextStyles.bodyMediumLight(locale: locale),
                      ),
                      trailing: Icon(
                        Helper.getDirectionalIcon(
                          context,
                          LineIcons.infoCircle,
                        ),
                        color: theme.iconTheme.color,
                      ),
                      onTap: _showPermissionsInfoDialog,
                    ),
                  ],
                ),

                const SizedBox(height: UniversalConstants.spacingLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
