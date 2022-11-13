import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> saveImageToLocalDirectory(File image) async {
  final documentDirectory = await getApplicationDocumentsDirectory();

  /// to interpolation
  final folderPath = '${documentDirectory.path}/medicine/images';
  final filepath = '$folderPath/${DateTime.now().millisecondsSinceEpoch}.png';

  await Directory(folderPath).create(recursive: true);

  final newFile = File(filepath);
  newFile.writeAsBytesSync(image.readAsBytesSync());

  return filepath;
}

void deleteImage(String filePath) {
  File(filePath).delete(recursive: true);
}
