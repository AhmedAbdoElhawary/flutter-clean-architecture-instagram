import 'package:universal_io/io.dart';

import 'package:image_picker/image_picker.dart';
import 'package:instagram/core/functions/compress_image.dart';
import 'package:instagram/core/utility/constant.dart';

Future<File?> imageCameraPicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(
      source: ImageSource.camera, maxWidth: double.infinity, maxHeight: 300);
  if (image != null) {
    File photo = File(image.path);
    if (isThatMobile) {
      File? compressPhoto = await compressImage(photo);
      return compressPhoto;
    } else {
      return photo;
    }
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
    if (isThatMobile) {
      File? compressPhoto = await compressImage(photo);
      return compressPhoto;
    } else {
      return photo;
    }
  } else {
    return null;
  }
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
