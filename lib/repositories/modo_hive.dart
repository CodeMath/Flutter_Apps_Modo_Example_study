import 'package:hive_flutter/hive_flutter.dart';

import 'package:modo/models/medicine.dart';
import 'package:modo/models/medicine_history.dart';

class ModoHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>((MedicineAdapter()));
    Hive.registerAdapter<MedicineHistory>((MedicineHistoryAdapter()));

    await Hive.openBox<Medicine>(ModoHiveBox.medicine);
    await Hive.openBox<MedicineHistory>(ModoHiveBox.medicineHistory);
  }
}

class ModoHiveBox {
  static const String medicine = 'medicine';
  static const String medicineHistory = 'medicine_history';
}
