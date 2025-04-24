import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Environment variables
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // App info
  static const String appName = 'Flutter Starter Template';
  static const String packageName = 'starter_template_flutter';
  static const String bundleId = 'com.example.starter_template_flutter';

  // App identifiers for each platform
  static const String appIdAndroid = 'com.example.starter_template_flutter';
  static const String appIdIos = 'com.example.starterTemplateFlutter';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('ar'), // Arabic
  ];

  // Theme settings
  static const bool useMaterial3 = true;

  // API settings
  static const Duration apiTimeout = Duration(seconds: 30);

  // Animation defaults
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Cache settings
  static const Duration cacheDuration = Duration(days: 7);
}
