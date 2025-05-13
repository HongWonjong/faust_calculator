import 'package:flutter/material.dart';

class AppStyles {
  // 색상
  static const Color primaryColor = Colors.redAccent;
  static const Color backgroundDark = Color(0xFF121212);
  static const Color backgroundGradientStart = Color(0xFF1A1A1A);
  static const Color backgroundGradientEnd = Color(0xFFB71C1C);
  static const Color textLight = Colors.white;
  static const Color textSecondary = Colors.grey;
  static const Color neonGlow = Colors.redAccent;
  static const Color accentGlow = Colors.white;

  // 폰트
  static const String fontFamily = 'RobotoCondensed';

  // 텍스트 스타일
  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textLight,
    letterSpacing: 1.2,
    shadows: [
      Shadow(
        color: neonGlow,
        blurRadius: 8,
        offset: Offset(0, 0),
      ),
    ],
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.6,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textLight,
  );

  // 버튼 스타일
  static final ButtonStyle googleButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: neonGlow, width: 1),
    ),
    elevation: 8,
    shadowColor: neonGlow.withOpacity(0.5),
  );

  // 애니메이션
  static const Duration animationDuration = Duration(milliseconds: 800);
  static const Duration sparkleDuration = Duration(seconds: 2);
  static const Curve animationCurve = Curves.easeInOut;

  // 그림자
  static const BoxShadow cardShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  static const BoxShadow neonGlowShadow = BoxShadow(
    color: neonGlow,
    blurRadius: 12,
    spreadRadius: 2,
  );

  // 그라디언트
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundGradientStart, backgroundGradientEnd],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryColor, Color(0xFFD81B60)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 패딩 및 마진
  static const EdgeInsets pagePadding = EdgeInsets.all(20);
  static const EdgeInsets cardPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 20);

  // 반짝임 효과 (별)
  static const List<Color> sparkleColors = [
    Colors.white,
    Colors.redAccent,
    Colors.grey,
  ];
}