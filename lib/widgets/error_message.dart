import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}