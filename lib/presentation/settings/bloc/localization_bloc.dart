import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization_event.dart';
import 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  static const String prefsLanguageCode = 'language_code';
  // Keep track of current language code for better state management
  String _currentLanguageCode = 'en';

  LocalizationBloc() : super(const LocalizationInitial(locale: Locale('en'))) {
    on<LocaleChanged>(_onLocaleChanged);
    _loadLocale();
  }

  String get currentLanguageCode => _currentLanguageCode;

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(prefsLanguageCode) ?? 'en';
    _currentLanguageCode = languageCode;
    add(LocaleChanged(languageCode: languageCode));
  }

  void _onLocaleChanged(
    LocaleChanged event,
    Emitter<LocalizationState> emit,
  ) async {
    _currentLanguageCode = event.languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsLanguageCode, event.languageCode);
    emit(LocalizationLoaded(locale: Locale(event.languageCode)));
  }
}
