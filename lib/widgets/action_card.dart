import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData icon;

  const ActionCard({
    super.key,
    required this.label,
    required this.onTap,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(color: Colors.pinkAccent.withOpacity(0.2)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.pinkAccent, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.pinkAccent.withOpacity(0.5),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}