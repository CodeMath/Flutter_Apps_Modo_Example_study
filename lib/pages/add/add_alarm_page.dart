import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modo/components/modo_colors.dart';
import 'package:modo/components/modo_constants.dart';
import 'package:modo/pages/add/components/add_page_widget.dart';

import '../../components/modo_widgets.dart';

class AddAlarmPage extends StatelessWidget {
  const AddAlarmPage(
      {Key? key, required this.medicineImage, required this.medicineName})
      : super(key: key);

  final File? medicineImage;
  final String medicineName;

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
            child: ListView(
          children: const [
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
            AddAlarmButton(),
          ],
        )),
      ]),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: () {},
        text: "완료",
      ),
    );
  }
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: () {}, icon: const Icon(CupertinoIcons.minus_circle)),
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
                        return BottomSheetBody(
                          children: [
                            SizedBox(
                              height: 200,
                              child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.time,
                                  onDateTimeChanged: (dateTime) {}),
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
                                            foregroundColor:
                                                ModoColors.primaryColor,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                            backgroundColor: Colors.white),
                                        onPressed: () {},
                                        child: const Text("취소")),
                                  ),
                                ),
                                const SizedBox(width: smallSpace),
                                Expanded(
                                  child: SizedBox(
                                    height: submitButtonHeight,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                        onPressed: () {},
                                        child: const Text("선택")),
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      });
                },
                child: const Text("18:00")))
      ],
    );
  }
}

class AddAlarmButton extends StatelessWidget {
  const AddAlarmButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          textStyle: Theme.of(context).textTheme.subtitle1),
      onPressed: () {},
      child: Row(
        children: const [
          Expanded(flex: 1, child: Icon(CupertinoIcons.plus_circle_fill)),
          Expanded(flex: 5, child: Center(child: Text("복용 시간 추가")))
        ],
      ),
    );
  }
}
