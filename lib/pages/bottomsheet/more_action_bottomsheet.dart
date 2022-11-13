import 'package:flutter/material.dart';

import '../../components/modo_widgets.dart';

class MoreActionBottomSheet extends StatelessWidget {
  const MoreActionBottomSheet({
    super.key,
    required this.onPressedModifiy,
    required this.onPressedDeleteOnlyMedicine,
    required this.onPressedDeleteAll,
  });

  final VoidCallback? onPressedModifiy;
  final VoidCallback? onPressedDeleteOnlyMedicine;
  final VoidCallback? onPressedDeleteAll;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(
      children: [
        TextButton(
          onPressed: onPressedModifiy,
          child: const Text("약 정보 수정"),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          onPressed: onPressedDeleteOnlyMedicine,
          child: const Text("약 정보 삭제"),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          onPressed: onPressedDeleteAll,
          child: const Text("약 기록과 함께 약 정보 삭제"),
        ),
      ],
    );
  }
}
