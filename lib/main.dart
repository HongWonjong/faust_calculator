import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/main_dashboard.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('Firebase initialized successfully');
  } catch (e) {
    log('Firebase initialization failed: $e');
  }

  runApp(const ProviderScope(child: FaustCalculatorApp()));
}

class FaustCalculatorApp extends StatelessWidget {
  const FaustCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '파우스트의 계산기',
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // 다크 모드 강제 적용
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main_dashboard': (context) => const MainDashboard(),
      },
    );
  }
}