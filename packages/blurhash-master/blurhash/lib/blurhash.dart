import 'dart:async';
import 'package:flutter/services.dart';

class BlurHash {
  static const MethodChannel _channel = MethodChannel('blurhash');

  static Future<String> encode(
      Uint8List image, int componentX, int componentY) async {
    final String blurHash =
        await _channel.invokeMethod('blurHashEncode', <String, dynamic>{
      "image": image,
      "componentX": componentX,
      "componentY": componentY,
    });
    return blurHash;
  }

  static Future<Uint8List> decode(String blurHash, int width, int height,
      {double punch = 1.0, bool useCache = true}) async {
    final Uint8List pixels =
        await _channel.invokeMethod('blurHashDecode', <String, dynamic>{
      "blurHash": blurHash,
      "width": width,
      "height": height,
      "punch": punch,
      "useCache": useCache
    });
    return pixels;
  }
}
