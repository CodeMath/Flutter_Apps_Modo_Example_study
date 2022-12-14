import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/modo_colors.dart';
import '../../components/modo_constants.dart';
import '../../components/modo_widgets.dart';

class TimeSettingBottomSheet extends StatelessWidget {
  const TimeSettingBottomSheet({
    super.key,
    required this.initialTime,
    this.submitTitle = "선택",
    this.bottomWidget,
  });

  final String initialTime;
  final Widget? bottomWidget;
  final String submitTitle;

  @override
  Widget build(BuildContext context) {
    final initialTimeData = DateFormat('HH:mm').parse(initialTime);
    final now = DateTime.now();
    final initialDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      initialTimeData.hour,
      initialTimeData.minute,
    );
    DateTime setDateTime = initialDateTime;

    return BottomSheetBody(
      children: [
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
              initialDateTime: initialDateTime,
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (dateTime) {
                setDateTime = dateTime;
              }),
        ),
        const SizedBox(height: smallSpace),
        if (bottomWidget != null) bottomWidget!,
        const SizedBox(height: smallSpace),
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
                      Navigator.pop(context, setDateTime);
                    },
                    child: Text(submitTitle)),
              ),
            )
          ],
        )
      ],
    );
  }
}
