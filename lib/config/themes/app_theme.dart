import 'package:flutter/material.dart';

/// App theme configuration
class AppTheme {
  AppTheme._(); // Private constructor

  /// Light theme for the application
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      fontFamily: 'Varela Round',
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      textTheme: _getTextTheme(Brightness.light),
      elevatedButtonTheme: _getElevatedButtonTheme(),
      inputDecorationTheme: _getInputDecorationTheme(Brightness.light),
    );
  }

  /// Dark theme for the application
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Varela Round',
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      textTheme: _getTextTheme(Brightness.dark),
      elevatedButtonTheme: _getElevatedButtonTheme(),
      inputDecorationTheme: _getInputDecorationTheme(Brightness.dark),
    );
  }

  /// Get the text theme based on brightness
  static TextTheme _getTextTheme(Brightness brightness) {
    final color = brightness == Brightness.light ? Colors.black : Colors.white;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      displaySmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: color),
      bodyMedium: TextStyle(fontSize: 14, color: color),
    );
  }

  /// Get the elevated button theme
  static ElevatedButtonThemeData _getElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Get the input decoration theme based on brightness
  static InputDecorationTheme _getInputDecorationTheme(Brightness brightness) {
    return InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor:
          brightness == Brightness.light
              ? Colors.grey.shade100
              : Colors.grey.shade800,
    );
  }
}
