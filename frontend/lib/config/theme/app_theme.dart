import 'package:flutter/material.dart';
import 'app_config.dart';

class AppTheme {
  static ThemeData getTheme(AppConfig config) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: config.primaryColor,
        primary: config.primaryColor,
        secondary: config.secondaryColor,
        surface: config.surfaceColor,
      ),
      scaffoldBackgroundColor: config.backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: config.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: config.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        ),
      ),
    );
  }
}
