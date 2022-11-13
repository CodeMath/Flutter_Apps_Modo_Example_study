import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modo/components/modo_constants.dart';
import 'package:modo/components/modo_page_route.dart';
import 'package:modo/components/modo_widgets.dart';
import 'package:modo/main.dart';
import 'package:modo/pages/add/add_alarm_page.dart';
import 'package:modo/pages/add/components/add_page_widget.dart';

import '../../models/medicine.dart';
import '../bottomsheet/pick_image_bottomsheet.dart';

class AddMedicinepage extends StatefulWidget {
  const AddMedicinepage({
    super.key,
    // -1 : Add , other: modify
    this.updateMedicineId = -1,
  });

  final int updateMedicineId;

  @override
  State<AddMedicinepage> createState() => _AddMedicinepageState();
}

class _AddMedicinepageState extends State<AddMedicinepage> {
  late TextEditingController _nameController;
  File? _medicineImage;

  // if update?
  get _isUpdate => widget.updateMedicineId != -1;
  Medicine get _updateMedicine =>
      medicineRepository.medicineBox.values.singleWhere(
        (medicine) => medicine.id == widget.updateMedicineId,
      );

  @override
  void initState() {
    super.initState();
    if (_isUpdate) {
      _nameController = TextEditingController(text: _updateMedicine.name);
      if (_updateMedicine.imagePath != null) {
        _medicineImage = File(_updateMedicine.imagePath!);
      }
    } else {
      _nameController = TextEditingController();
    }
  }

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
              child: _MedicineImageButton(
                updateImage: _medicineImage,
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
                updateMedicineId: widget.updateMedicineId,
                medicineImage: _medicineImage,
                medicineName: _nameController.text)));
  }
}

class _MedicineImageButton extends StatefulWidget {
  const _MedicineImageButton({
    required this.changeImageFile,
    this.updateImage,
  });

  final ValueChanged<File?> changeImageFile;
  final File? updateImage;

  @override
  State<_MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<_MedicineImageButton> {
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _pickedImage = widget.updateImage;
  }

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
    }).onError((error, stackTrace) {
      // show setting
      Navigator.pop(context);
      showPermissionDeneid(context, permission: "카메라 및 갤러리 접근");
    });
  }
}
