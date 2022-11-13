import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:modo/components/modo_themes.dart';
import 'package:modo/pages/homepage.dart';
import 'package:modo/repositories/medicine_history_repository.dart';
import 'package:modo/repositories/medicine_repository.dart';
import 'package:modo/repositories/modo_hive.dart';
import 'package:modo/services/modo_notification_service.dart';

final notification = ModoNotificationService();
final hive = ModoHive();
final medicineRepository = MedicineRepository();
final historyRepository = MedicineHistoryRepository();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  // Alarm
  await notification.initializeTimeZone();
  await notification.initializeNotification();

  // DB
  await hive.initializeHive();

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
