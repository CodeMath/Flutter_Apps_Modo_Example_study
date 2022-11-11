import 'package:flutter/material.dart';
import 'package:modo/components/modo_themes.dart';
import 'package:modo/pages/homepage.dart';
import 'package:modo/services/modo_notification_service.dart';

final notification = ModoNotificationService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  notification.initializeTimeZone();
  notification.initializeNotification();

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
