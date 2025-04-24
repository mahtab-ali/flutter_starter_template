import 'dart:ui';

import '../../core/errors/result.dart';

/// Interface for localization operations
abstract class LocalizationRepository {
  /// Get the current locale
  Future<Result<Locale>> getCurrentLocale();

  /// Set the current locale
  Future<Result<void>> setLocale(Locale locale);

  /// Check if a locale is supported
  bool isSupportedLocale(Locale locale);

  /// Get all supported locales
  List<Locale> getSupportedLocales();
}
