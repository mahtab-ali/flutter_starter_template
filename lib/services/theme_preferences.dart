import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const String _themeKey = 'app_theme_mode';

  // Save theme preference (dark mode or light mode)
  static Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  // Clear theme preference to use system theme
  static Future<void> clearThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeKey);
  }

  // Get saved theme preference, default to system theme (null value)
  static Future<bool?> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    // Returns null if no preference is set (will use system theme)
    return prefs.containsKey(_themeKey) ? prefs.getBool(_themeKey) : null;
  }
}
