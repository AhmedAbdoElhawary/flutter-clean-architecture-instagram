import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/core/functions/compress_image.dart';

Future<File?> imageCameraPicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  if (image != null) {
    File photo = File(image.path);
    File? compressPhoto = await compressFile(photo);
    return compressPhoto;
  } else {
    return null;
  }
}

Future<File?> imageGalleryPicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    File photo = File(image.path);
    File? compressPhoto = await compressFile(photo);
    return compressPhoto;
  } else {
    return null;
  }
}

Future<File?> videoCameraPicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
  if (video != null) {
    File videoFile = File(video.path);
    File? compressVideo = await compressFile(videoFile);
    return compressVideo;
  } else {
    return null;
  }
}
