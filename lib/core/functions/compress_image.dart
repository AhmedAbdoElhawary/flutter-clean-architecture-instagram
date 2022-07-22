import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List?> compressImage(Uint8List file) async {
  if (file.lengthInBytes > 200000) {
    Uint8List? result = await FlutterImageCompress.compressWithList(
      file,
      quality: file.lengthInBytes > 5000000 ? 90 : 72,
    );
    return result;
  } else {
    return file;
  }
}
