import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = AppTheme.backgroundDark,
  });

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          color: widget.backgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.neonGlow.withOpacity(_isHovered ? 0.8 : 0.3),
            width: 1,
          ),
          boxShadow: _isHovered ? [AppTheme.neonGlowShadow] : [],
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: AppTheme.cardPadding,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}