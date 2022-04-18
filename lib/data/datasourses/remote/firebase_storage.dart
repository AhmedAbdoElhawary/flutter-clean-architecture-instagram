import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';

class FirebaseStoragePost {
  static Future<String> uploadFile(File postFile, String folderName) async {
    final fileName = basename(postFile.path);
    final destination = 'files/$folderName/$fileName';
    final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
    UploadTask uploadTask = ref.putFile(postFile);
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
