import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _primaryColor = Color(0xFF1F2937);
  static const Color _accentColor = Color(0xFFE50914);
  static const Color _backgroundColor = Color(0xFF111827);
  static const Color _cardColor = Color(0xFF374151);
  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _textSecondary = Color(0xFF9CA3AF);

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: _backgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: _accentColor,
      surface: _primaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryColor,
      foregroundColor: _textPrimary,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: _cardColor,
      elevation: 4,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: _textPrimary,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: _textSecondary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: _textSecondary),
    ),
  );
}