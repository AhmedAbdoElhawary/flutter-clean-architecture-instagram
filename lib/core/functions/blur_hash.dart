import 'dart:isolate';
import 'dart:typed_data';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart';

class CustomBlurHash {
  static Future<String> blurHashEncode(Uint8List bytes) => Isolate.run(() {
    /// decoding and encoding in dart, so keep it off the ui thread and on a tiny image
    final image = copyResize(decodeImage(bytes)!, width: 32);
    return BlurHash.encode(image, numCompX: 4, numCompY: 3).hash;
  });
}
