import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/main_dashboard.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: FaustCalculatorApp()));
}

class FaustCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '파우스트의 계산기',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.redAccent,
        fontFamily: 'RobotoCondensed',
        cardTheme: CardTheme(color: Colors.grey[900], elevation: 4),
      ),
      home: Consumer(
        builder: (context, ref, _) {
          final authState = ref.watch(authStateProvider);
          return authState.when(
            data: (user) => user != null ? MainDashboard() : LoginScreen(),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          );
        },
      ),
    );
  }
}