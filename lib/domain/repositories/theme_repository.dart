import '../../core/errors/result.dart';

/// Interface for theme operations
abstract class ThemeRepository {
  /// Get whether dark mode is currently enabled
  Future<Result<bool>> isDarkModeEnabled();

  /// Set whether dark mode is enabled
  Future<Result<void>> setDarkModeEnabled(bool isDarkMode);

  /// Get whether system theme is being used
  Future<Result<bool>> isSystemThemeEnabled();

  /// Set whether to use system theme
  Future<Result<void>> setSystemThemeEnabled(bool useSystemTheme);
}
