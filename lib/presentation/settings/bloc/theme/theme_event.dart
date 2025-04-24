abstract class ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  // When isDarkMode is null, it means use system theme
  final bool? isDarkMode;

  ThemeChanged({this.isDarkMode});
}

// Event to use system theme
class UseSystemTheme extends ThemeEvent {}

// Event to initialize theme on app start
class InitializeTheme extends ThemeEvent {}
