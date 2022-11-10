import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// ChangeNotifier 로 받는 쪽에서 새롭게 빌드 할 수 있게
class AddMedicineService with ChangeNotifier {
  final _alarms = <String>{'08:00', '13:00', '19:00'};

  Set<String> get alarms => _alarms;

  void addNowAlarm() {
    final now = DateTime.now();
    final nowTime = DateFormat('HH:mm').format(now);
    _alarms.add(nowTime);
    // 빌더 기반으로 새롭게 그려짐
    notifyListeners();
  }

  void removeAlarm(String alarmTime) {
    _alarms.remove(alarmTime);
    notifyListeners();
  }

  void setAlarm({required String prevTime, required DateTime setTime}) {
    _alarms.remove(prevTime);
    final setTimeStr = DateFormat('HH:mm').format(setTime);
    _alarms.add(setTimeStr);
    notifyListeners();
  }
}
