import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/core/functions/compress_image.dart';

Future<File?> imageCameraPicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(
      source: ImageSource.camera, maxWidth: double.infinity, maxHeight: 300);
  if (image != null) {
    File photo = File(image.path);
    File? compressPhoto = await compressImage(photo);
    return compressPhoto;
  } else {
    return null;
  }
}

Future<File?> imageGalleryPicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, maxWidth: double.infinity, maxHeight: 300);
  if (image != null) {
    File photo = File(image.path);
    File? compressPhoto = await compressImage(photo);
    return compressPhoto;
  } else {
    return null;
  }
}

Future<List<File>?> multiImageGalleryPicker() async {
  final ImagePicker _picker = ImagePicker();
  final List<XFile>? images =
      await _picker.pickMultiImage(maxHeight: 300, maxWidth: double.infinity);
  List<File>? compressImages;
  if (images != null) {
    compressImages = [];
    for (int i = 0; i < images.length; i++) {
      File photo = File(images[i].path);
      File? compressPhoto = await compressImage(photo);
      if (compressPhoto != null) compressImages.add(compressPhoto);
    }
  }
  return compressImages;
}

Future<File?> videoCameraPicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
  if (video != null) {
    File videoFile = File(video.path);
    File? compressV = await compressVideo(videoFile);
    return compressV;
  } else {
    return null;
  }
}

Future<File?> videoGalleryPicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
  if (video != null) {
    File videoFile = File(video.path);
    File? compressV = await compressVideo(videoFile);
    return compressV;
  } else {
    return null;
  }
}
