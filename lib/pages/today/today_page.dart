import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modo/components/modo_constants.dart';

class TodayPage extends StatelessWidget {
  TodayPage({
    super.key,
  });

  final list = [
    '약1',
    '약2',
    '약3',
    '약4',
  ];
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
        const Divider(height: 1, thickness: 2.0),
        Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: regularSpace),
                itemCount: list.length,
                itemBuilder: ((context, index) {
                  return MedicineListTile(
                    name: list[index],
                  );
                }),
                // 구분 해줄 때 어떤 구분 값 위젯 반환할 지?
                separatorBuilder: ((context, index) {
                  return const Divider(height: regularSpace);
                })))
      ],
    );
  }
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(
      children: [
        CupertinoButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          child: const CircleAvatar(
            radius: 40,
          ),
        ),
        const SizedBox(
          width: smallSpace,
        ),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("🕑08:30", style: textStyle),
            const SizedBox(height: 6),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "약이름, 먹었어요!",
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
          ]),
        ),
        CupertinoButton(
            onPressed: () {},
            child: const Icon(CupertinoIcons.ellipsis_vertical))
      ],
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
        ?.copyWith(fontWeight: FontWeight.w500);
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
