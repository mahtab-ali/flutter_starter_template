import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/theme_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeInitial(isDarkMode: null)) {
    on<ThemeChanged>(_onThemeChanged);
    on<UseSystemTheme>(_onUseSystemTheme);
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDarkMode = await ThemePreferences.getDarkMode();
    add(ThemeChanged(isDarkMode: isDarkMode));
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) async {
    // Save the preference (null for system theme, or a boolean for light/dark mode)
    if (event.isDarkMode != null) {
      await ThemePreferences.setDarkMode(event.isDarkMode!);
    }
    emit(ThemeLoaded(isDarkMode: event.isDarkMode));
  }

  void _onUseSystemTheme(UseSystemTheme event, Emitter<ThemeState> emit) async {
    // Clear the saved preference to use system theme
    await ThemePreferences.clearThemePreference();
    emit(ThemeLoaded(isDarkMode: null));
  }
}
