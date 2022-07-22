import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

class FirebaseStoragePost {
  static Future<String> uploadFile(Uint8List postUint8List, String folderName,
      {File? postFile}) async {
    final fileName =
        postFile != null ? basename(postFile.path) : DateTime.now().toString();
    final destination = 'files/$folderName/$fileName';
    final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
    UploadTask uploadTask =
        postFile != null ? ref.putFile(postFile) : ref.putData(postUint8List);
    var fileOfPostUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return fileOfPostUrl.toString();
  }

  static Future<void> deleteImageFromStorage(String previousImageUrl) async {
    String previousFileUrl = Uri.decodeFull(basename(previousImageUrl))
        .replaceAll(RegExp(r'(\?alt).*'), '');
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(previousFileUrl);
    await firebaseStorageRef.delete().then((value) {});
  }
}
