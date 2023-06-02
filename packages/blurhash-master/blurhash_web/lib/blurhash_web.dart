import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class BlurHashPlugin {
  static void registerWith(Registrar registrar) {
    const MethodChannel channel =
        MethodChannel('blurhash', StandardMethodCodec());
    final BlurHashPlugin instance = BlurHashPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'blurHashEncode':
        final Uint8List imageData = call.arguments['image'];
        final int componentX = call.arguments['componentX'];
        final int componentY = call.arguments['componentY'];
        final image = img.decodeImage(imageData);
        BlurHash blurhash =
            BlurHash.encode(image!, numCompX: componentX, numCompY: componentY);
        return blurhash.hash;
      case 'blurHashDecode':
        final String hash = call.arguments['blurHash'];
        final int width = call.arguments['width'];
        final int height = call.arguments['height'];
        final double punch = call.arguments['punch'];
        BlurHash blurHash = BlurHash.decode(hash, punch: punch);
        img.Image image = blurHash.toImage(width, height);
        return Uint8List.fromList(img.encodeJpg(image));
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The blurhash plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }
}
