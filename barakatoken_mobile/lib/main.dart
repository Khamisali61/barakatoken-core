import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakatoken_mobile/core/theme/app_theme.dart';
import 'package:barakatoken_mobile/features/dashboard/presentation/dashboard_screen.dart';
import 'package:barakatoken_mobile/features/auth/presentation/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: BarakaTokenApp()));
}

class BarakaTokenApp extends StatelessWidget {
  const BarakaTokenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarakaToken',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
