import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      surface: Colors.white,
      primary: Colors.deepPurple,
    ),
    dividerTheme: const DividerThemeData(color: Colors.grey),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
