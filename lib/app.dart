import 'package:flutter/material.dart';
import 'package:nonprofit_app/constants/app_theme.dart';
import 'package:nonprofit_app/screens/home_screen.dart';

class NonprofitApp extends StatelessWidget {
  const NonprofitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hope Foundation',
      theme: AppTheme.theme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
