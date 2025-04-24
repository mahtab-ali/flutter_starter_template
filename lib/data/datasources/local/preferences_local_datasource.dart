import 'dart:ui';

/// Interface for managing local preferences
abstract class PreferencesLocalDataSource {
  /// Get the stored locale
  Future<Locale?> getLocale();

  /// Save the locale
  Future<void> saveLocale(Locale locale);

  /// Get whether dark mode is enabled
  Future<bool> isDarkModeEnabled();

  /// Set whether dark mode is enabled
  Future<void> setDarkModeEnabled(bool isDarkMode);

  /// Get whether system theme is enabled
  Future<bool> isSystemThemeEnabled();

  /// Set whether system theme is enabled
  Future<void> setSystemThemeEnabled(bool useSystemTheme);

  /// Get whether onboarding has been completed
  Future<bool> isOnboardingCompleted();

  /// Set onboarding as completed
  Future<void> setOnboardingCompleted(bool completed);
}
