import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modo/main.dart';

import 'package:modo/components/modo_constants.dart';
import 'package:modo/pages/add/components/add_page_widget.dart';
import 'package:modo/services/add_medicine_service.dart';

import '../../components/modo_widgets.dart';
import '../../models/medicine.dart';
import '../../services/modo_file_service.dart';
import '../bottomsheet/time_setting_bottomsheet.dart';

// ignore: must_be_immutable
class AddAlarmPage extends StatelessWidget {
  AddAlarmPage(
      {Key? key,
      required this.medicineImage,
      required this.medicineName,
      required this.updateMedicineId})
      : super(key: key) {
    service = AddMedicineService(updateMedicineId);
  }

  final int updateMedicineId;
  final File? medicineImage;
  final String medicineName;

  late AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(children: [
        Text(
          "매일 복약 잊지 말아요!",
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: largeSpace,
        ),
        Expanded(
            child: AnimatedBuilder(
          animation: service,
          builder: (context, _) {
            return ListView(
              children: alarmWidgets,
            );
          },
        )),
      ]),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: () async {
          final isUpdate = updateMedicineId != -1;
          isUpdate
              ? await _onUpdateMedicine(context)
              : await _onAddMedicine(context);
        },
        text: "완료",
      ),
    );
  }

  Future<void> _onUpdateMedicine(BuildContext context) async {
    bool result = false;
    // 1-1. delete previous alarm
    final alarmIds = _updateMedicine.alarms
        .map((alarmTime) => notification.alarmId(updateMedicineId, alarmTime));
    await notification.deleteMultipleAlarm(alarmIds);

    // 1-2. add alarm
    for (var alarm in service.alarms) {
      result = await notification.addNotifications(
        // id : 1+ 08:00 > 10800
        medicineId: updateMedicineId,
        alarmTimeStr: alarm,
        title: "$alarm 약 먹을 시간이에요!",
        body: "$medicineName 복약했다고 알려주세요!",
      );

      if (!result) {
        // ignore: use_build_context_synchronously
        return showPermissionDeneid(context, permission: "알람 접근 권한");
      }
    }

    String? imageFilePath = _updateMedicine.imagePath;
    if (_updateMedicine.imagePath != medicineImage?.path) {
      // 2-1. delete previous image
      if (_updateMedicine.imagePath != null) {
        deleteImage(_updateMedicine.imagePath!);
      }
      // 2-2. save image(local dir) & text
      if (medicineImage != null) {
        imageFilePath = await saveImageToLocalDirectory(medicineImage!);
      }
    }

    // 3. update medicine
    final medicine = Medicine(
      id: updateMedicineId,
      alarms: service.alarms.toList(),
      imagePath: imageFilePath,
      name: medicineName,
    );

    // Updae
    medicineRepository.updateMedicine(
      key: _updateMedicine.key,
      medicine: medicine,
    );

    // 메인으로
    // ignore: use_build_context_synchronously
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> _onAddMedicine(BuildContext context) async {
    // 1. add alarm
    bool result = false;

    for (var alarm in service.alarms) {
      result = await notification.addNotifications(
        // id : 1+ 08:00 > 10800
        medicineId: medicineRepository.newId,
        alarmTimeStr: alarm,
        title: "$alarm 약 먹을 시간이에요!",
        body: "$medicineName 복약했다고 알려주세요!",
      );

      if (!result) {
        // ignore: use_build_context_synchronously
        return showPermissionDeneid(context, permission: "알람 접근 권한");
      }
    }

    // 2. save image(local dir) & text
    // android Up to SDK 31 version
    String? imageFilePath;
    if (medicineImage != null) {
      imageFilePath = await saveImageToLocalDirectory(medicineImage!);
    }

    // 3. add medicine model (local DB, hive)
    final medicine = Medicine(
        id: medicineRepository.newId,
        alarms: service.alarms.toList(),
        imagePath: imageFilePath,
        name: medicineName);
    medicineRepository.addMedicine(medicine);
    // 메인으로
    // ignore: use_build_context_synchronously
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  List<Widget> get alarmWidgets {
    final children = <Widget>[];
    children.addAll(service.alarms.map((alarmTime) => AlarmBox(
          time: alarmTime,
          service: service,
        )));

    children.add(AddAlarmButton(
      service: service,
    ));
    return children;
  }

  Medicine get _updateMedicine =>
      medicineRepository.medicineBox.values.singleWhere(
        (medicine) => medicine.id == updateMedicineId,
      );
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    super.key,
    required this.time,
    required this.service,
  });

  final String time;
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: () {
                service.removeAlarm(time);
              },
              icon: const Icon(CupertinoIcons.minus_circle)),
        ),
        Expanded(
            flex: 5,
            child: TextButton(
                style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.subtitle2),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return TimeSettingBottomSheet(
                        initialTime: time,
                      );
                    },
                  ).then((value) {
                    if (value == null || value is! DateTime) return;
                    service.setAlarm(
                      prevTime: time,
                      setTime: value,
                    );
                  });
                },
                child: Text(time)))
      ],
    );
  }
}

class AddAlarmButton extends StatelessWidget {
  const AddAlarmButton({
    super.key,
    required this.service,
  });

  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          textStyle: Theme.of(context).textTheme.subtitle1),
      onPressed: service.addNowAlarm,
      child: Row(
        children: const [
          Expanded(flex: 1, child: Icon(CupertinoIcons.plus_circle_fill)),
          Expanded(flex: 5, child: Center(child: Text("복용 시간 추가")))
        ],
      ),
    );
  }
}
