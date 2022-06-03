import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';

Future<File?> compressImage(File file) async {
  final filePath = file.absolute.path;

  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final split = filePath.substring(0, (lastIndex));
  final outPath = "${split}_out${filePath.substring(lastIndex)}";
  if (file.lengthSync() > 200000) {
    File? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: file.lengthSync() > 5000000 ? 90 : 75,
    );
    return result;
  } else {
    return file;
  }
}

Future<File?> compressVideo(File file) async {
  if (file.lengthSync() > 500000) {
    MediaInfo? result = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      includeAudio: true,
    );
    return result!.file;
  } else {
    return file;
  }
}
