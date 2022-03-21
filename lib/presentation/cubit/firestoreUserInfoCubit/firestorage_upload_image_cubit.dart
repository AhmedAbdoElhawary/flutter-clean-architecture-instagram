import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/domain/usecases/firestoreUsecase/upload_image_usecase.dart';
part 'firestorage_upload_image_state.dart';

class FireStorageImageCubit extends Cubit<FireStorageImageState> {
  UploadImageUseCase uploadImageUseCase;
  FireStorageImageCubit(this.uploadImageUseCase) : super(CubitInitial());

  static FireStorageImageCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> uploadProfileImage(File photo, String userId) async {
    emit(CubitImageLoading());
    await uploadImageUseCase.call(params: [photo, userId]).then((imageUrl) {
      emit(CubitImageLoaded(imageUrl));
    }).catchError((e) {
      emit(CubitImageFailed(e));
    });
  }
}
