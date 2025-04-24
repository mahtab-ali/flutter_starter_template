import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/result.dart';
import 'package:starter_template_flutter/domain/usecases/theme/get_system_theme_status_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/theme/get_theme_mode_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/theme/set_system_theme_status_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/theme/set_theme_mode_use_case.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetThemeModeUseCase? _getThemeModeUseCase;
  final GetSystemThemeStatusUseCase? _getSystemThemeStatusUseCase;
  final SetThemeModeUseCase? _setThemeModeUseCase;
  final SetSystemThemeStatusUseCase? _setSystemThemeStatusUseCase;

  ThemeBloc({
    GetThemeModeUseCase? getThemeModeUseCase,
    GetSystemThemeStatusUseCase? getSystemThemeStatusUseCase,
    SetThemeModeUseCase? setThemeModeUseCase,
    SetSystemThemeStatusUseCase? setSystemThemeStatusUseCase,
  }) : _getThemeModeUseCase = getThemeModeUseCase,
       _getSystemThemeStatusUseCase = getSystemThemeStatusUseCase,
       _setThemeModeUseCase = setThemeModeUseCase,
       _setSystemThemeStatusUseCase = setSystemThemeStatusUseCase,
       super(const ThemeInitial(isDarkMode: null)) {
    on<ThemeChanged>(_onThemeChanged);
    on<UseSystemTheme>(_onUseSystemTheme);
    on<InitializeTheme>(_onInitializeTheme);

    // Trigger theme initialization
    add(InitializeTheme());
  }

  void _onInitializeTheme(
    InitializeTheme event,
    Emitter<ThemeState> emit,
  ) async {
    if (_getSystemThemeStatusUseCase != null) {
      final systemThemeResult = await _getSystemThemeStatusUseCase();

      final useSystemTheme = systemThemeResult.getSuccessOrNull();
      if (useSystemTheme == true) {
        // If system theme is enabled, use it
        emit(ThemeLoaded(isDarkMode: null));
        return;
      }
    }

    if (_getThemeModeUseCase != null) {
      final themeResult = await _getThemeModeUseCase();
      final isDarkMode = themeResult.getSuccessOrNull();

      if (isDarkMode != null) {
        emit(ThemeLoaded(isDarkMode: isDarkMode));
      } else {
        // Fallback to default light theme if use cases are not available or failed
        emit(const ThemeLoaded(isDarkMode: false));
      }
    } else {
      // Fallback to default light theme if use cases are not available
      emit(const ThemeLoaded(isDarkMode: false));
    }
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) async {
    // First, disable system theme
    if (_setSystemThemeStatusUseCase != null) {
      await _setSystemThemeStatusUseCase(false);
    }

    // Then, set the specific theme mode
    if (_setThemeModeUseCase != null && event.isDarkMode != null) {
      await _setThemeModeUseCase(event.isDarkMode!);
    }

    // Emit new state with language preserved
    emit(ThemeLoaded(isDarkMode: event.isDarkMode));
  }

  void _onUseSystemTheme(UseSystemTheme event, Emitter<ThemeState> emit) async {
    // Save the system theme preference
    if (_setSystemThemeStatusUseCase != null) {
      await _setSystemThemeStatusUseCase(true);
    }

    emit(const ThemeLoaded(isDarkMode: null));
  }
}
