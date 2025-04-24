import 'package:flutter/material.dart';
import 'package:starter_template_flutter/domain/repositories/auth_repository.dart';

import '../../domain/usecases/auth/check_auth_status_use_case.dart';
import '../../domain/usecases/auth/get_current_user_use_case.dart';
import '../../domain/usecases/localization/get_current_locale_use_case.dart';
import '../../domain/usecases/onboarding/check_onboarding_status_use_case.dart';
import '../../domain/usecases/theme/get_system_theme_status_use_case.dart';
import '../../domain/usecases/theme/get_theme_mode_use_case.dart';
import '../di/injection_container.dart';
import '../errors/result.dart';

/// Service responsible for app initialization and configuration
class AppService {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final CheckOnboardingStatusUseCase _checkOnboardingStatusUseCase;
  final GetThemeModeUseCase _getThemeModeUseCase;
  final GetSystemThemeStatusUseCase _getSystemThemeStatusUseCase;
  final GetCurrentLocaleUseCase _getCurrentLocaleUseCase;

  /// Create a new AppService with required use cases
  AppService({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required CheckOnboardingStatusUseCase checkOnboardingStatusUseCase,
    required GetThemeModeUseCase getThemeModeUseCase,
    required GetSystemThemeStatusUseCase getSystemThemeStatusUseCase,
    required GetCurrentLocaleUseCase getCurrentLocaleUseCase,
  }) : _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _checkOnboardingStatusUseCase = checkOnboardingStatusUseCase,
       _getThemeModeUseCase = getThemeModeUseCase,
       _getSystemThemeStatusUseCase = getSystemThemeStatusUseCase,
       _getCurrentLocaleUseCase = getCurrentLocaleUseCase;

  /// Create an instance using the service locator
  factory AppService.fromServiceLocator() {
    return AppService(
      checkAuthStatusUseCase: sl<CheckAuthStatusUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      checkOnboardingStatusUseCase: sl<CheckOnboardingStatusUseCase>(),
      getThemeModeUseCase: sl<GetThemeModeUseCase>(),
      getSystemThemeStatusUseCase: sl<GetSystemThemeStatusUseCase>(),
      getCurrentLocaleUseCase: sl<GetCurrentLocaleUseCase>(),
    );
  }

  /// Initialize the app by loading all necessary data
  Future<AppInitializationResult> initialize() async {
    // Get onboarding status
    final onboardingResult = await _checkOnboardingStatusUseCase();
    final isOnboardingCompleted = onboardingResult.getSuccessOrNull() ?? false;

    // Check authentication status
    final authResult = await _checkAuthStatusUseCase();
    final isAuthenticated = authResult.getSuccessOrNull() ?? false;

    // Get current theme settings
    final isDarkMode =
        (await _getThemeModeUseCase()).getSuccessOrNull() ?? false;
    final useSystemTheme =
        (await _getSystemThemeStatusUseCase()).getSuccessOrNull() ?? true;

    // Get locale
    final localeResult = await _getCurrentLocaleUseCase();
    final locale = localeResult.getSuccessOrNull();

    // Get user if authenticated
    final user =
        isAuthenticated
            ? (await _getCurrentUserUseCase()).getSuccessOrNull()
            : null;

    return AppInitializationResult(
      isAuthenticated: isAuthenticated,
      isOnboardingCompleted: isOnboardingCompleted,
      isDarkMode: isDarkMode,
      useSystemTheme: useSystemTheme,
      locale: locale,
      user: user,
    );
  }
}

/// Result of the app initialization process
class AppInitializationResult {
  /// Whether the user is authenticated
  final bool isAuthenticated;

  /// Whether onboarding is completed
  final bool isOnboardingCompleted;

  /// Whether dark mode is enabled
  final bool isDarkMode;

  /// Whether to use system theme
  final bool useSystemTheme;

  /// Current locale
  final Locale? locale;

  /// Current authenticated user if any
  final UserEntity? user;

  const AppInitializationResult({
    required this.isAuthenticated,
    required this.isOnboardingCompleted,
    required this.isDarkMode,
    required this.useSystemTheme,
    this.locale,
    this.user,
  });
}
