import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization_event.dart';
import 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  static const String PREFS_LANGUAGE_CODE = 'language_code';

  LocalizationBloc() : super(const LocalizationInitial(locale: Locale('en'))) {
    on<LocaleChanged>(_onLocaleChanged);
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(PREFS_LANGUAGE_CODE) ?? 'en';
    add(LocaleChanged(languageCode: languageCode));
  }

  void _onLocaleChanged(
    LocaleChanged event,
    Emitter<LocalizationState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PREFS_LANGUAGE_CODE, event.languageCode);
    emit(LocalizationLoaded(locale: Locale(event.languageCode)));
  }
}
