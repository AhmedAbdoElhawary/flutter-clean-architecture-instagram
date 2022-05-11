import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> compressFile(File file) async {
  final filePath = file.absolute.path;

  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final split = filePath.substring(0, (lastIndex));
  final outPath = "${split}_out${filePath.substring(lastIndex)}";
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    quality: 5,
  );

  print(file.lengthSync());
  print(result!.lengthSync());

  return result;
}
