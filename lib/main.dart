import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CareerConnectApp());
}

/// Root widget for the CareerConnect application.
class CareerConnectApp extends StatelessWidget {
  const CareerConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareerConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
