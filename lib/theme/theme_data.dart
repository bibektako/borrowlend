import 'package:flutter/material.dart';

ThemeData getApplicationTheme(){
  return ThemeData(
    useMaterial3: false,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white
    ),
    fontFamily: 'Inter Regular'
  );
}