import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingErrorWidget extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final Widget child;

  const LoadingErrorWidget({
    super.key,
    required this.isLoading,
    this.error,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Text(
          'Error: $error',
          style: AppTheme.subtitle.copyWith(color: Colors.redAccent),
        ),
      );
    }
    return child;
  }
}