import 'package:flutter/material.dart';

const Color _lightPrimaryColor = Color(0xFF0D47A1);
const Color _lightAccentColor = Color(0xFF00BFA5);
const Color _lightScaffoldBgColor = Color(0xFFF9F9F9);
const Color _lightTextColorPrimary = Color(0xFF1A1A1A);
const Color _lightTextColorSecondary = Color(0xFF6E6E6E);

const Color _darkPrimaryColor = Color(0xFF42A5F5);
const Color _darkAccentColor = Color(0xFF00BFA5);
const Color _darkScaffoldBgColor = Color(0xFF121212);
const Color _darkSurfaceColor = Color(0xFF1E1E1E);
const Color _darkTextColorPrimary = Color(0xFFE0E0E0);
const Color _darkTextColorSecondary = Color(0xFFBDBDBD);
const Color _darkErrorColor = Color(0xFFCF6679);

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: false,
    fontFamily: 'Inter Regular',
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: _lightPrimaryColor,
      secondary: _lightAccentColor,
      background: _lightScaffoldBgColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: _lightTextColorPrimary,
      onSurface: _lightTextColorPrimary,
      error: Colors.redAccent,
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: _lightScaffoldBgColor,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: _lightTextColorPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter Bold',
      ),
      iconTheme: IconThemeData(color: _lightTextColorPrimary),
      actionsIconTheme: IconThemeData(color: _lightTextColorPrimary),
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: _lightTextColorSecondary),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _lightPrimaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter Bold',
        ),
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: _lightTextColorPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: _lightTextColorSecondary, fontSize: 14),
      titleLarge: TextStyle(
        color: _lightTextColorPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

ThemeData getDarkApplicationTheme() {
  return ThemeData(
    useMaterial3: false,
    fontFamily: 'Inter Regular',
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      primary: _darkPrimaryColor,
      secondary: _darkAccentColor,
      background: _darkScaffoldBgColor,
      surface: _darkSurfaceColor,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onBackground: _darkTextColorPrimary,
      onSurface: _darkTextColorPrimary,
      error: _darkErrorColor,
      onError: Colors.black,
    ),

    scaffoldBackgroundColor: _darkScaffoldBgColor,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: _darkSurfaceColor,
      titleTextStyle: TextStyle(
        color: _darkTextColorPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter Bold',
      ),
      iconTheme: IconThemeData(color: _darkTextColorPrimary),
      actionsIconTheme: IconThemeData(color: _darkTextColorPrimary),
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: _darkTextColorSecondary),
      filled: true,
      fillColor: _darkSurfaceColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkPrimaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkErrorColor, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkErrorColor, width: 1.5),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter Bold',
        ),
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 2.0,
      shadowColor: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color:
          _darkSurfaceColor, // Explicitly set the card color to your dark surface color
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: _darkTextColorPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: _darkTextColorSecondary, fontSize: 14),
      titleLarge: TextStyle(
        color: _darkTextColorPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
