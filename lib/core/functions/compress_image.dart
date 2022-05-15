import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';

Future<File?> compressFile(File file, {bool isThatImage = true}) async {
  final filePath = file.absolute.path;

  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final split = filePath.substring(0, (lastIndex));
  final outPath = "${split}_out${filePath.substring(lastIndex)}";
  if (file.lengthSync() > 200000) {
    File? result = isThatImage
        ? await FlutterImageCompress.compressAndGetFile(
            file.absolute.path,
            outPath,
            quality: file.lengthSync() > 5000000 ? 70 : 50,
          )
        : await VideoCompress.getFileThumbnail(
            file.absolute.path,
            quality: file.lengthSync() > 5000000 ? 70 : 50,
          );
    return result;
  } else {
    return file;
  }
}
