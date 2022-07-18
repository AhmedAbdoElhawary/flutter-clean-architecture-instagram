import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:instagram/core/functions/compress_image.dart';
import 'package:instagram/core/utility/constant.dart';

Future<Uint8List?> imageCameraPicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(
      source: ImageSource.camera, maxWidth: double.infinity, maxHeight: 300);
  if (image != null) {

    Uint8List photo = await image.readAsBytes();
    if (isThatMobile) {
      Uint8List? compressPhoto = await compressImage(photo);
      return compressPhoto;
    } else {
      return photo;
    }
  } else {
    return null;
  }
}

Future<Uint8List?> imageGalleryPicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, maxWidth: double.infinity, maxHeight: 300);
  if (image != null) {
    Uint8List photo = await image.readAsBytes();
    if (isThatMobile) {
      Uint8List? compressPhoto = await compressImage(photo);
      return compressPhoto;
    } else {
      return photo;
    }
  } else {
    return null;
  }
}

Future<Uint8List?> videoCameraPicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
  if (video != null) {
    Uint8List videoFile = await video.readAsBytes();
    return videoFile;
  } else {
    return null;
  }
}
