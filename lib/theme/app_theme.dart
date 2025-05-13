import 'package:flutter/material.dart';
import 'style.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppStyles.primaryColor,
        surface: AppStyles.backgroundDark,
      ),
      fontFamily: AppStyles.fontFamily,
      cardTheme: CardTheme(
        color: AppStyles.backgroundDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppStyles.googleButtonStyle,
      ),
      scaffoldBackgroundColor: AppStyles.backgroundDark,
      textTheme: TextTheme(
        headlineMedium: AppStyles.headline, // headline6 → headlineMedium
        titleMedium: AppStyles.subtitle,   // subtitle1 → titleMedium
        labelLarge: AppStyles.buttonText,  // button → labelLarge
      ),
    );
  }
}