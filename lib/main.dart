import 'package:flutter/material.dart';
import 'package:modo/components/modo_themes.dart';
import 'package:modo/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MODO App', theme: ModoTheme.ligntTheme, home: const HomePage());
  }
}
