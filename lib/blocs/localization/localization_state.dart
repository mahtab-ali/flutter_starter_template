import 'package:flutter/material.dart';

abstract class LocalizationState {
  final Locale locale;

  const LocalizationState({required this.locale});
}

class LocalizationInitial extends LocalizationState {
  const LocalizationInitial({required super.locale});
}

class LocalizationLoaded extends LocalizationState {
  const LocalizationLoaded({required super.locale});
}
