import 'package:flutter/material.dart';
import 'package:tttf_demo_app/screens/start_screen.dart';
import 'package:tttf_demo_app/theme/app_theme.dart';

void main() {
  runApp(const IslandGuideApp());
}

class IslandGuideApp extends StatelessWidget {
  const IslandGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '島めぐりAIガイド（デモ）',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const StartScreen(),
    );
  }
}