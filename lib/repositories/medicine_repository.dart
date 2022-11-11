import 'dart:developer';

import 'package:modo/repositories/modo_hive.dart';
import 'package:hive/hive.dart';

import 'package:modo/models/medicine.dart';

class MedicineRepository {
  Box<Medicine>? _medicineBox;

  Box<Medicine> get medicineBox {
    // if(_medicineBox == null){_medicineBox = Hive.box<Medicine>(ModoHiveBox.medicine)};
    // _medicineBox 가 null 인 경우 하이브 박스 객체 만들어라
    // 멤버 변수로 할당하게 되면 안되는 케이스: main 에서 init 한 뒤 생성되어야 하므로
    _medicineBox ??= Hive.box<Medicine>(ModoHiveBox.medicine);

    return _medicineBox!;
  }

  void addMedicine(Medicine medicine) async {
    int key = await medicineBox.add(medicine);

    log('[addMedicine] add (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  void deleteMedicine(int key) async {
    await medicineBox.delete(key);
    log('[addMedicine] delete (key:$key)');
    log('result ${medicineBox.values.toList()}');
  }

  void updateMedicine({
    required int key,
    required Medicine medicine,
  }) async {
    await medicineBox.put(key, medicine);
    log('[addMedicine] update (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  int get newId {
    final lastId = medicineBox.values.isEmpty ? 0 : medicineBox.values.last.id;
    return lastId + 1;
  }
}
