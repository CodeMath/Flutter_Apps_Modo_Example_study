import 'package:flutter/material.dart';
import 'package:modo/components/modo_constants.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:modo/models/medicine_history.dart';
import 'package:modo/pages/today/today_empty_widget.dart';
import 'package:modo/pages/today/today_take_tile.dart';

import '../../main.dart';
import '../../models/medicine.dart';
import '../../models/medicine_alarm.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "오늘 복용할 약은?",
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: regularSpace),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: medicineRepository.medicineBox.listenable(),
            builder: _builderMedicineListView,
          ),
        ),
      ],
    );
  }

  Widget _builderMedicineListView(BuildContext context, Box<Medicine> box, _) {
    final medicines = box.values.toList();
    final medicineAlarms = <MedicineAlarm>[];

    // empty 일 때,
    if (medicines.isEmpty) {
      return const TodayEmpty();
    }

    for (var medicine in medicines) {
      for (var alarm in medicine.alarms) {
        medicineAlarms.add(MedicineAlarm(
          medicine.id,
          medicine.name,
          medicine.imagePath,
          alarm,
          medicine.key,
        ));
      }
    }

    return Column(
      children: [
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: smallSpace),
            itemCount: medicineAlarms.length,
            itemBuilder: (context, index) {
              return _buildListTile(medicineAlarms[index]);
            },
            // 구분 해줄 때 어떤 구분 값 위젯 반환할 지?
            separatorBuilder: (context, index) {
              return const Divider(height: regularSpace);
            },
          ),
        ),
        const Divider(height: 1, thickness: 1.0),
      ],
    );
  }
}

Widget _buildListTile(MedicineAlarm medicineAlarm) {
  return ValueListenableBuilder(
      valueListenable: historyRepository.historyBox.listenable(),
      builder: (context, Box<MedicineHistory> historyBox, _) {
        if (historyBox.values.isEmpty) {
          return BeforeTakeTile(
            medicineAlarm: medicineAlarm,
          );
        } else {
          /// isToday(history.takeTime!, DateTime.now()) null 값 처리
          /// // 이렇게도 줄일 수 있음.
          // history.takeTime.difference(DateTime.now()).inDays == 0

          final todayTakeHistory = historyBox.values.singleWhere(
            (history) =>
                history.medicineId == medicineAlarm.id &&
                history.medicineKey == medicineAlarm.key &&
                history.alarmTime == medicineAlarm.alarmTime &&
                isToday(
                  history.takeTime,
                  DateTime.now(),
                ),
            orElse: () => MedicineHistory(
              name: '',
              imagePath: null,
              medicineId: -1,
              alarmTime: "",
              takeTime: DateTime.now(),
              medicineKey: -1,
            ),
          );

          if (todayTakeHistory.medicineId == -1 &&
              todayTakeHistory.alarmTime == '') {
            return BeforeTakeTile(
              medicineAlarm: medicineAlarm,
            );
          } else {
            return AfterTakeTile(
              medicineAlarm: medicineAlarm,
              history: todayTakeHistory,
            );
          }
        }
      });
}

bool isToday(DateTime source, DateTime destination) {
  return source.year == destination.year &&
      source.month == destination.month &&
      source.day == destination.day;
}
