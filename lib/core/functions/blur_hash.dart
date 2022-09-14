import 'dart:typed_data';
import 'package:blurhash/blurhash.dart';

class CustomBlurHash {
  static Future<String> blurHashEncode(Uint8List pixels) async {
    String result = await BlurHash.encode(pixels, 4, 3);
    return result;
  }
}
