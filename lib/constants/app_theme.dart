import 'package:flutter/material.dart';

class AppTheme {
  // Color Constants
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color secondaryPurple = Color(0xFFBA68C8);
  static const Color lightPurple = Color(0xFFAB47BC);
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color cardBackground = Color(0xFF1A1A1A);
  static const Color darkGrey = Color(0xFF2A2A2A);

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.purple,
      scaffoldBackgroundColor: darkBackground,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: secondaryPurple,
        surface: cardBackground,
        background: darkBackground,
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
      ),
    );
  }

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: secondaryPurple,
  );

  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: secondaryPurple,
  );

  static const TextStyle timerStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: secondaryPurple,
  );

  static TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey[300],
  );
}
