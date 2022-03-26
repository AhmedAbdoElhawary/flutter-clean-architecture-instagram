import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';

class FirebaseStorageImage {
  static Future<String> uploadImage(File photo, String folderName) async {
    final fileName = basename(photo.path);
    final destination = 'files/$folderName/$fileName';
    final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
    UploadTask uploadTask = ref.putFile(photo);
    var imageUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return imageUrl.toString();
  }

  static Future<void> deleteImageFromStorage(String previousImageUrl) async {
    String previousFileUrl = Uri.decodeFull(basename(previousImageUrl))
        .replaceAll(RegExp(r'(\?alt).*'), '');
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(previousFileUrl);
    await firebaseStorageRef.delete().then((value) {});
  }
}
