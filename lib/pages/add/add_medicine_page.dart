import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modo/components/modo_constants.dart';
import 'package:modo/components/modo_page_route.dart';
import 'package:modo/components/modo_widgets.dart';
import 'package:modo/pages/add/add_alarm_page.dart';
import 'package:modo/pages/add/components/add_page_widget.dart';

class AddMedicinepage extends StatefulWidget {
  const AddMedicinepage({super.key});

  @override
  State<AddMedicinepage> createState() => _AddMedicinepageState();
}

class _AddMedicinepageState extends State<AddMedicinepage> {
  final TextEditingController _nameController = TextEditingController();
  File? _medicineImage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
        ),
        body: SingleChildScrollView(
          child: AddPageBody(children: [
            Text(
              "어떤 약이에요?",
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: largeSpace),
            Center(
              child: MedicineImageButton(
                changeImageFile: (File? value) {
                  _medicineImage = value;
                },
              ),
            ),
            const SizedBox(height: largeSpace + regularSpace),
            Text(
              "약 이름",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            TextFormField(
              controller: _nameController,
              maxLength: 20,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              style: Theme.of(context).textTheme.bodyText2,
              decoration: InputDecoration(
                hintText: "복용할 약 이름을 기입해주세요.",
                hintStyle: Theme.of(context).textTheme.bodyText2,
                contentPadding: textFieldContentPadding,
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
          ]),
        ),
        bottomNavigationBar: BottomSubmitButton(
            onPressed: _nameController.text.isEmpty ? null : _onAddAlarmPage,
            text: "다음"));
  }

  void _onAddAlarmPage() {
    Navigator.push(
        context,
        FadePageRoute(
            page: AddAlarmPage(
                medicineImage: _medicineImage,
                medicineName: _nameController.text)));
  }
}

class MedicineImageButton extends StatefulWidget {
  const MedicineImageButton({super.key, required this.changeImageFile});

  final ValueChanged<File?> changeImageFile;

  @override
  State<MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<MedicineImageButton> {
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: CupertinoButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        padding: _pickedImage == null ? null : EdgeInsets.zero,
        child: _pickedImage == null
            ? const Icon(Icons.camera_alt_outlined,
                size: 30, color: Colors.white)
            : CircleAvatar(
                foregroundImage: FileImage(_pickedImage!),
                radius: 40,
              ),
      ),
    );
  }

  Future<dynamic> _showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return PickImageBottomSheet(
            onPressedCamera: () {
              _onPressedCamera(ImageSource.camera);
            },
            onPressedGallery: () {
              _onPressedCamera(ImageSource.gallery);
            },
          );
        });
  }

  void _onPressedCamera(ImageSource source) {
    ImagePicker().pickImage(source: source).then((xfile) {
      if (xfile != null) {
        setState(() {
          _pickedImage = File(xfile.path);
          widget.changeImageFile(_pickedImage);
        });
      }
      Navigator.maybePop(context);
    });
  }
}

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet({
    super.key,
    required this.onPressedCamera,
    required this.onPressedGallery,
  });

  final VoidCallback? onPressedCamera;
  final VoidCallback? onPressedGallery;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(
      children: [
        TextButton(onPressed: onPressedCamera, child: const Text("카메라로 촬영")),
        TextButton(onPressed: onPressedGallery, child: const Text("앨범에서 가져오기")),
      ],
    );
  }
}
