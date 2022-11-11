import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modo/main.dart';
import 'package:intl/intl.dart';
import 'package:modo/components/modo_colors.dart';
import 'package:modo/components/modo_constants.dart';
import 'package:modo/pages/add/components/add_page_widget.dart';
import 'package:modo/services/add_medicine_service.dart';

import '../../components/modo_widgets.dart';

class AddAlarmPage extends StatelessWidget {
  AddAlarmPage(
      {Key? key, required this.medicineImage, required this.medicineName})
      : super(key: key);

  final File? medicineImage;
  final String medicineName;

  final service = AddMedicineService();

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
          // 1. add alarm
          bool result = false;

          for (var alarm in service.alarms) {
            result = await notification.addNotifications(
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
          // 3. add medicine model (local DB, hive)
        },
        text: "완료",
      ),
    );
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
                        return TimePickerBottomSheet(
                          initialTime: time,
                          service: service,
                        );
                      });
                },
                child: Text(time)))
      ],
    );
  }
}

// ignore: must_be_immutable
class TimePickerBottomSheet extends StatelessWidget {
  TimePickerBottomSheet({
    super.key,
    required this.initialTime,
    required this.service,
  });

  final String initialTime;
  final AddMedicineService service;
  DateTime? _setDateTime;

  @override
  Widget build(BuildContext context) {
    final initialDateTime = DateFormat('HH:mm').parse(initialTime);

    return BottomSheetBody(
      children: [
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
              initialDateTime: initialDateTime,
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (dateTime) {
                _setDateTime = dateTime;
              }),
        ),
        const SizedBox(
          height: regularSpace,
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: ModoColors.primaryColor,
                        textStyle: Theme.of(context).textTheme.subtitle1,
                        backgroundColor: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("취소")),
              ),
            ),
            const SizedBox(width: smallSpace),
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.subtitle1,
                    ),
                    onPressed: () {
                      service.setAlarm(
                          prevTime: initialTime,
                          setTime: _setDateTime ?? initialDateTime);
                      Navigator.pop(context);
                    },
                    child: const Text("선택")),
              ),
            )
          ],
        )
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
