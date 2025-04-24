import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/errors/exceptions.dart';
import 'preferences_local_datasource.dart';

/// Implementation of [PreferencesLocalDataSource] using SharedPreferences
class SharedPreferencesLocalDataSource implements PreferencesLocalDataSource {
  final SharedPreferences sharedPreferences;

  // Keys for SharedPreferences
  static const String localeLanguageCodeKey = 'locale_language_code';
  static const String localeCountryCodeKey = 'locale_country_code';
  static const String darkModeKey = 'dark_mode';
  static const String systemThemeKey = 'use_system_theme';
  static const String onboardingCompletedKey = 'onboarding_completed';

  /// Create a new instance with the provided [SharedPreferences]
  SharedPreferencesLocalDataSource(this.sharedPreferences);

  @override
  Future<Locale?> getLocale() async {
    try {
      final languageCode = sharedPreferences.getString(localeLanguageCodeKey);
      if (languageCode == null) return null;

      final countryCode = sharedPreferences.getString(localeCountryCodeKey);
      return Locale(languageCode, countryCode);
    } catch (e) {
      throw CacheException('Failed to get locale from SharedPreferences');
    }
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    try {
      await sharedPreferences.setString(
        localeLanguageCodeKey,
        locale.languageCode,
      );

      if (locale.countryCode != null) {
        await sharedPreferences.setString(
          localeCountryCodeKey,
          locale.countryCode!,
        );
      } else {
        await sharedPreferences.remove(localeCountryCodeKey);
      }
    } catch (e) {
      throw CacheException('Failed to save locale to SharedPreferences');
    }
  }

  @override
  Future<bool> isDarkModeEnabled() async {
    try {
      return sharedPreferences.getBool(darkModeKey) ?? false;
    } catch (e) {
      throw CacheException(
        'Failed to get dark mode setting from SharedPreferences',
      );
    }
  }

  @override
  Future<void> setDarkModeEnabled(bool isDarkMode) async {
    try {
      await sharedPreferences.setBool(darkModeKey, isDarkMode);
    } catch (e) {
      throw CacheException(
        'Failed to save dark mode setting to SharedPreferences',
      );
    }
  }

  @override
  Future<bool> isSystemThemeEnabled() async {
    try {
      return sharedPreferences.getBool(systemThemeKey) ?? true;
    } catch (e) {
      throw CacheException(
        'Failed to get system theme setting from SharedPreferences',
      );
    }
  }

  @override
  Future<void> setSystemThemeEnabled(bool useSystemTheme) async {
    try {
      await sharedPreferences.setBool(systemThemeKey, useSystemTheme);
    } catch (e) {
      throw CacheException(
        'Failed to save system theme setting to SharedPreferences',
      );
    }
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    try {
      return sharedPreferences.getBool(onboardingCompletedKey) ?? false;
    } catch (e) {
      throw CacheException(
        'Failed to get onboarding status from SharedPreferences',
      );
    }
  }

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    try {
      await sharedPreferences.setBool(onboardingCompletedKey, completed);
    } catch (e) {
      throw CacheException(
        'Failed to save onboarding status to SharedPreferences',
      );
    }
  }
}
