import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modo/components/modo_constants.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:modo/components/modo_page_route.dart';
import 'package:modo/pages/today/today_empty_widget.dart';

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
              return MedicineListTile(
                medicineAlarm: medicineAlarms[index],
              );
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

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(
      children: [
        CupertinoButton(
          onPressed: medicineAlarm.imagePath == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    FadePageRoute(
                      page: ImageDetailPage(medicineAlarm: medicineAlarm),
                    ),
                  );
                },
          padding: EdgeInsets.zero,
          child: CircleAvatar(
            radius: 40,
            foregroundImage: medicineAlarm.imagePath == null
                ? null
                : FileImage(File(medicineAlarm.imagePath!)),
          ),
        ),
        const SizedBox(
          width: smallSpace,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🕑${medicineAlarm.alarmTime}", style: textStyle),
              const SizedBox(height: 6),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "약: ${medicineAlarm.name}, ",
                    style: textStyle,
                  ),
                  TileActionButton(
                    onTap: () {},
                    title: '지금',
                  ),
                  Text(
                    "|",
                    style: textStyle,
                  ),
                  TileActionButton(
                    onTap: () {},
                    title: '아까',
                  ),
                  Text(
                    "먹었어요.",
                    style: textStyle,
                  ),
                ],
              )
            ],
          ),
        ),
        CupertinoButton(
            onPressed: () {
              medicineRepository.deleteMedicine(medicineAlarm.key);
            },
            child: const Icon(CupertinoIcons.ellipsis_vertical))
      ],
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: Center(
          child: Image.file(
        File(medicineAlarm.imagePath!),
      )),
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
        ?.copyWith(fontWeight: FontWeight.w500, color: Colors.blue);
    return GestureDetector(
      onTap: () {
        onTap;
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        // 한 부분만 복사하려할 때 사용 copyWidth
        child: Text(title, style: buttontextStyle),
      ),
    );
  }
}
