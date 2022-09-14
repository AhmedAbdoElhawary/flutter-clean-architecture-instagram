import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompressImage {
  static Future<Uint8List?> compressByte(Uint8List? file) async {
    if (file == null) return null;
    if (file.lengthInBytes > 200000) {
      Uint8List? result = await FlutterImageCompress.compressWithList(
        file,
        quality: file.lengthInBytes > 4000000 ? 90 : 72,
      );
      return result;
    } else {
      return file;
    }
  }

  static Future<File?> compressFile(File? file) async {
    if (file == null) return null;
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final split = filePath.substring(0, (lastIndex));
    final outPath = "${split}_out${filePath.substring(lastIndex)}";
    File? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 5,
    );
    return result;
  }
}
