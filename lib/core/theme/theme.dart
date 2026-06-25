import 'package:flutter/material.dart';

class AppTheme {
  // Common Colors
  static const Color primaryColor = Color(0xFFF24E1E);

  // Light Theme Colors
  static const Color lightBackground = Colors.white;
  static const Color lightTextColor = Color(0xFF242E37);
  static const Color lightTextHintColor = Color(0xFF5C6771);
  static const Color lightBorderColor = Color(0xFFEBECED);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkTextColor = Color(0xFFE0E0E0);
  static const Color darkTextHintColor = Color(0xFF9E9E9E);
  static const Color darkBorderColor = Color(0xFF333333);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        surface: lightBackground,
        onSurface: lightTextColor,
        onSurfaceVariant: lightTextHintColor,
        outline: lightBorderColor,
        error: Colors.red,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: lightTextColor),
        bodyMedium: TextStyle(color: lightTextColor),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        surface: darkBackground,
        onSurface: darkTextColor,
        onSurfaceVariant: darkTextHintColor,
        outline: darkBorderColor,
        error: Colors.red,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkTextColor),
        bodyMedium: TextStyle(color: darkTextColor),
      ),
    );
  }
}
