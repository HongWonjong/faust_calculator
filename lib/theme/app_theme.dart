import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.redAccent;
  static const Color secondaryColor = Colors.cyanAccent;
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color neonGlow = Colors.cyanAccent;
  static const Color textColor = Colors.white;
  static const Color textSecondaryColor = Colors.white70;

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const BoxShadow neonGlowShadow = BoxShadow(
    color: neonGlow,
    blurRadius: 10,
    spreadRadius: 2,
  );

  static const TextStyle headline = TextStyle(
    color: textColor,
    fontWeight: FontWeight.bold,
    fontSize: 32,
    shadows: [neonGlowShadow],
  );

  static const TextStyle subtitle = TextStyle(
    color: textSecondaryColor,
    fontSize: 16,
  );

  static const TextStyle bodyText = TextStyle(
    color: textColor,
    fontSize: 16,
  );

  static const EdgeInsets pagePadding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);

  // 다크 테마 정의
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.transparent, // 그라디언트 배경을 위해 투명 설정
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: headline,
        titleMedium: subtitle,
        bodyMedium: bodyText,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: backgroundDark.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: neonGlow.withOpacity(0.3),
            width: 1,
          ),
        ),
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white10,
        hintStyle: subtitle,
        labelStyle: bodyText,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: secondaryColor,
        unselectedLabelColor: textSecondaryColor,
        indicatorColor: secondaryColor,
        labelStyle: bodyText.copyWith(fontSize: 16),
      ),
    );
  }
}