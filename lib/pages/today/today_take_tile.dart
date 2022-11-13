import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modo/pages/add/add_medicine_page.dart';
import 'package:modo/pages/bottomsheet/more_action_bottomsheet.dart';
import 'package:modo/pages/today/image_detail_page.dart';

import '../../components/modo_constants.dart';
import '../../components/modo_page_route.dart';

import '../../models/medicine_alarm.dart';
import '../../models/medicine_history.dart';
import '../../main.dart';
import '../bottomsheet/time_setting_bottomsheet.dart';

class BeforeTakeTile extends StatelessWidget {
  const BeforeTakeTile({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(
      children: [
        MedicineImageButton(imagePath: medicineAlarm.imagePath),
        const SizedBox(
          width: smallSpace,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTileBody(textStyle, context),
          ),
        ),
        _MoreButton(medicineAlarm: medicineAlarm)
      ],
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
      Text("🕑${medicineAlarm.alarmTime}", style: textStyle),
      const SizedBox(height: 6),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "💊 ${medicineAlarm.name}, ",
            style: textStyle,
          ),
          TileActionButton(
            onTap: () {
              historyRepository.addHistory(MedicineHistory(
                name: medicineAlarm.name,
                imagePath: medicineAlarm.imagePath,
                medicineId: medicineAlarm.id,
                alarmTime: medicineAlarm.alarmTime,
                takeTime: DateTime.now(),
                medicineKey: medicineAlarm.key,
              ));
            },
            title: '지금',
          ),
          Text("|", style: textStyle),
          TileActionButton(
            onTap: () => _onPreviousTake(context),
            title: '아까',
          ),
          Text(
            "먹었어요.",
            style: textStyle,
          ),
        ],
      )
    ];
  }

  void _onPreviousTake(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TimeSettingBottomSheet(
        initialTime: medicineAlarm.alarmTime,
      ),
    ).then((takeDateTime) {
      if (takeDateTime == null || takeDateTime is! DateTime) {
        return;
      }
      historyRepository.addHistory(MedicineHistory(
        name: medicineAlarm.name,
        imagePath: medicineAlarm.imagePath,
        medicineId: medicineAlarm.id,
        medicineKey: medicineAlarm.key,
        alarmTime: medicineAlarm.alarmTime,
        takeTime: takeDateTime,
      ));
    });
  }
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    Key? key,
    required this.medicineAlarm,
    required this.history,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;
  final MedicineHistory history;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(
      children: [
        Stack(
          children: [
            MedicineImageButton(imagePath: medicineAlarm.imagePath),
            CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green.withOpacity(0.8),
                child: const Icon(
                  CupertinoIcons.check_mark,
                  color: Colors.white,
                ))
          ],
        ),
        const SizedBox(
          width: smallSpace,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTileBody(textStyle, context),
          ),
        ),
        _MoreButton(medicineAlarm: medicineAlarm)
      ],
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
      Text.rich(TextSpan(
          text: "✅${medicineAlarm.alarmTime} → ",
          style: textStyle,
          children: [
            TextSpan(
              text: takeTimeStr,
              style: textStyle?.copyWith(fontWeight: FontWeight.w700),
            ),
          ])),
      const SizedBox(height: 6),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "💊 ${medicineAlarm.name}, ",
            style: textStyle,
          ),
          TileActionButton(
            onTap: () => _onTap(context),
            title: DateFormat('HH시 mm분에').format(history.takeTime),
          ),
          Text(
            "먹었어요.",
            style: textStyle,
          ),
        ],
      )
    ];
  }

  String get takeTimeStr => DateFormat('HH:mm').format(history.takeTime);

  void _onTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TimeSettingBottomSheet(
        initialTime: takeTimeStr,
        submitTitle: "수정",
        bottomWidget: TextButton(
            onPressed: () {
              historyRepository.deleteHistory(history.key);
              Navigator.pop(context);
            },
            child: Text(
              "복약 시간을 지우고 싶어요.",
              style: Theme.of(context).textTheme.bodyText2,
            )),
      ),
    ).then((takeDateTime) {
      if (takeDateTime == null || takeDateTime is! DateTime) {
        return;
      }
      historyRepository.updateHistory(
        key: history.key,
        history: MedicineHistory(
          name: medicineAlarm.name,
          imagePath: medicineAlarm.imagePath,
          medicineKey: medicineAlarm.key,
          medicineId: medicineAlarm.id,
          alarmTime: medicineAlarm.alarmTime,
          takeTime: takeDateTime,
        ),
      );
    });
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        onPressed: () {
          // medicineRepository.deleteMedicine(medicineAlarm.key);
          showModalBottomSheet(
              context: context,
              builder: (context) => MoreActionBottomSheet(
                    onPressedModifiy: () {
                      Navigator.push(
                        context,
                        FadePageRoute(
                            page: AddMedicinepage(
                          updateMedicineId: medicineAlarm.id,
                        )),
                      ).then((_) => Navigator.maybePop(context));
                    },
                    onPressedDeleteOnlyMedicine: () {
                      //1. 알람 삭제 - id 값을 알기 위해
                      notification.deleteMultipleAlarm(alarmIds);
                      //2. 이후 hive 데이터 삭제
                      medicineRepository.deleteMedicine(medicineAlarm.key);
                      //3. navigator.pop
                      Navigator.pop(context);
                    },
                    onPressedDeleteAll: () {
                      //1. 알람 삭제 - id 값을 알기 위해
                      notification.deleteMultipleAlarm(alarmIds);
                      //2. hive 히스토리 데이터 삭제
                      historyRepository.deleteAllHistory(keys);
                      //3. 이후 hive 데이터 삭제
                      medicineRepository.deleteMedicine(medicineAlarm.key);
                      //4. navigator.pop
                      Navigator.pop(context);
                    },
                  ));
        },
        child: const Icon(CupertinoIcons.ellipsis_vertical));
  }

  List<String> get alarmIds {
    final medicine = medicineRepository.medicineBox.values
        .singleWhere((element) => element.id == medicineAlarm.id);
    final alarmIds = medicine.alarms
        .map((alarmStr) => notification.alarmId(medicineAlarm.id, alarmStr))
        .toList();
    return alarmIds;
  }

  Iterable<int> get keys {
    final histories = historyRepository.historyBox.values.where((history) =>
        history.medicineId == medicineAlarm.id &&
        history.medicineKey == medicineAlarm.key);
    final keys = histories.map((e) => e.key as int);

    return keys;
  }
}

class MedicineImageButton extends StatelessWidget {
  const MedicineImageButton({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: imagePath == null
          ? null
          : () {
              Navigator.push(
                context,
                FadePageRoute(
                  page: ImageDetailPage(imagePath: imagePath!),
                ),
              );
            },
      padding: EdgeInsets.zero,
      child: CircleAvatar(
        radius: 40,
        foregroundImage: imagePath == null ? null : FileImage(File(imagePath!)),
        child: imagePath == null ? const Icon(CupertinoIcons.alarm_fill) : null,
      ),
    );
  }
}

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    final buttontextStyle = Theme.of(context)
        .textTheme
        .bodyText2
        ?.copyWith(fontWeight: FontWeight.w700);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        // 한 부분만 복사하려할 때 사용 copyWidth
        child: Text(title, style: buttontextStyle),
      ),
    );
  }
}
