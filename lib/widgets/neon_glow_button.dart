import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeonGlowButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double fontSize;

  const NeonGlowButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppTheme.primaryColor,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [AppTheme.neonGlowShadow],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}