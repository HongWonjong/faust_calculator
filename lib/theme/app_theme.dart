import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.redAccent,
      fontFamily: 'RobotoCondensed',
      cardTheme: CardTheme(color: Colors.grey[900], elevation: 4),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
      ),
    );
  }
}