import 'package:universal_io/io.dart';
import 'dart:typed_data';
import 'package:blurhash/blurhash.dart';

Future<String> blurHashEncode(File file) async {
  Uint8List pixels = file.readAsBytesSync();
  String result = await BlurHash.encode(pixels, 4, 3);
  return result;
}
