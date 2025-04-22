abstract class ThemeState {
  final bool? isDarkMode;
  
  // If isDarkMode is null, it means we're using the system theme
  bool get isSystemTheme => isDarkMode == null;

  const ThemeState({this.isDarkMode});
}

class ThemeInitial extends ThemeState {
  const ThemeInitial({super.isDarkMode});
}

class ThemeLoaded extends ThemeState {
  const ThemeLoaded({super.isDarkMode});
}
