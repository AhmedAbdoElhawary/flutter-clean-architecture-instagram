// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// void main() {
//   const MethodChannel channel = MethodChannel('blurhash');
//
//   setUp(() {
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       if (methodCall.method == 'blurHashDecode') {
//         return null;
//       }
//     });
//   });
//
//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });
//
//   test('blurHashDecode', () async {
//     var bytes = await BlurHash.decode("", 32, 32);
//     expect(bytes, null);
//   });
// }
