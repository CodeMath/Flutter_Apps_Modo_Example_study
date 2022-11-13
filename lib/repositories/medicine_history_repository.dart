import 'dart:developer';
import 'package:hive/hive.dart';

import 'package:modo/repositories/modo_hive.dart';
import 'package:modo/models/medicine_history.dart';

class MedicineHistoryRepository {
  Box<MedicineHistory>? _historyBox;

  Box<MedicineHistory> get historyBox {
    // if(_medicineBox == null){_medicineBox = Hive.box<Medicine>(ModoHiveBox.medicine)};
    // _medicineBox 가 null 인 경우 하이브 박스 객체 만들어라
    // 멤버 변수로 할당하게 되면 안되는 케이스: main 에서 init 한 뒤 생성되어야 하므로
    _historyBox ??= Hive.box<MedicineHistory>(ModoHiveBox.medicineHistory);

    return _historyBox!;
  }

  void addHistory(MedicineHistory history) async {
    int key = await historyBox.add(history);

    log('[addHistory] add (key:$key) $history');
    log('result ${historyBox.values.toList()}');
  }

  void deleteHistory(int key) async {
    await historyBox.delete(key);
    log('[addHistory] delete (key:$key)');
    log('result ${historyBox.values.toList()}');
  }

  void deleteAllHistory(Iterable<int> keys) async {
    await historyBox.deleteAll(keys);
    log('[addHistory] delete All (key: $keys)');
    log('result ${historyBox.values.toList()}');
  }

  void updateHistory({
    required int key,
    required MedicineHistory history,
  }) async {
    await historyBox.put(key, history);
    log('[addHistory] update (key:$key) $history');
    log('result ${historyBox.values.toList()}');
  }
}
