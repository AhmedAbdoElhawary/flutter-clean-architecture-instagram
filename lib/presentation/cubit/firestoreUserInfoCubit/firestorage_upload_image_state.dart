part of '../firestoreUserInfoCubit/firestorage_upload_image_cubit.dart';

abstract class FireStorageImageState {}

class CubitInitial extends FireStorageImageState {}

class CubitImageLoading extends FireStorageImageState {}

class CubitImageLoaded extends FireStorageImageState {
  String imageUrl;

  CubitImageLoaded(this.imageUrl);
}

class CubitImageFailed extends FireStorageImageState {
  final String error;
  CubitImageFailed(this.error);
}
