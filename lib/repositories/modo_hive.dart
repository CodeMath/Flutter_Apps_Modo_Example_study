import 'package:hive_flutter/hive_flutter.dart';

import 'package:modo/models/medicine.dart';

class ModoHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>((MedicineAdapter()));

    await Hive.openBox<Medicine>(ModoHiveBox.medicine);
  }
}

class ModoHiveBox {
  static const String medicine = 'medicine';
}
