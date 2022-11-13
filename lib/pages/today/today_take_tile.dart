import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modo/pages/today/image_detail_page.dart';

import '../../components/modo_constants.dart';
import '../../components/modo_page_route.dart';
import '../../main.dart';
import '../../models/medicine_alarm.dart';
import '../../models/medicine_history.dart';
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
        _MedicineImageButton(medicineAlarm: medicineAlarm),
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
            onTap: () {
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
                  medicineId: medicineAlarm.id,
                  alarmTime: medicineAlarm.alarmTime,
                  takeTime: takeDateTime,
                ));
              });
            },
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
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(
      children: [
        Stack(
          children: [
            _MedicineImageButton(medicineAlarm: medicineAlarm),
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
              text: " 20:19",
              style: textStyle?.copyWith(fontWeight: FontWeight.w700),
            ),
          ])),
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
            title: '20시 19분 에',
          ),
          Text(
            "먹었어요.",
            style: textStyle,
          ),
        ],
      )
    ];
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
          medicineRepository.deleteMedicine(medicineAlarm.key);
        },
        child: const Icon(CupertinoIcons.ellipsis_vertical));
  }
}

class _MedicineImageButton extends StatelessWidget {
  const _MedicineImageButton({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
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
