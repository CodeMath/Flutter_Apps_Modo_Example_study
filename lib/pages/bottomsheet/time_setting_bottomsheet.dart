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
  });

  final String initialTime;

  @override
  Widget build(BuildContext context) {
    final initialDateTime = DateFormat('HH:mm').parse(initialTime);
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
                      Navigator.pop(context, setDateTime);
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
