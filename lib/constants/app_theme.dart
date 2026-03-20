import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF4A90D9);
  static const Color accentColor = Color(0xFF50C878);
  static const Color darkBg = Color(0xFF1A1A2E);
  static const Color cardBg = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);

  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: textSecondary,
          ),
        ),
        useMaterial3: true,
      );
}
