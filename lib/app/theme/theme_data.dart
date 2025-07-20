import 'package:flutter/material.dart';

const Color _primaryColor = Color(0xFF0D47A1); // A deep, professional blue
const Color _accentColor = Color(0xFF00BFA5); // A vibrant teal for accents
const Color _scaffoldBgColor = Color(0xFFF9F9F9);
const Color _textColorPrimary = Color(0xFF1A1A1A); 
const Color _textColorSecondary = Color(
  0xFF6E6E6E,
); 

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: false,
    fontFamily: 'Inter Regular',

    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: _accentColor,
      background: _scaffoldBgColor,
      surface: Colors.white,
      onPrimary: Colors.white, // Text/icons on top of the primary color
      onSecondary: Colors.white,
      onBackground: _textColorPrimary,
      onSurface: _textColorPrimary,
      error: Colors.redAccent,
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: _scaffoldBgColor,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: _textColorPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter Bold',
      ),
      iconTheme: IconThemeData(color: _textColorPrimary),
      actionsIconTheme: IconThemeData(color: _textColorPrimary),
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: _textColorSecondary),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        // Use the primary color from your new scheme
        borderSide: const BorderSide(color: _primaryColor, width: 1.5),
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
        backgroundColor: _primaryColor,
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
      bodyLarge: TextStyle(color: _textColorPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: _textColorSecondary, fontSize: 14),
      titleLarge: TextStyle(
        color: _textColorPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
