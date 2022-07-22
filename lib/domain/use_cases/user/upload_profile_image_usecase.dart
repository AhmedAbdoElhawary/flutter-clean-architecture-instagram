import 'dart:typed_data';
import 'package:instagram/core/use_case/use_case.dart';
import '../../repositories/user_repository.dart';

class UploadProfileImageUseCase
    implements UseCaseThreeParams<String, Uint8List, String, String> {
  final FirestoreUserRepository _addNewUserRepository;

  UploadProfileImageUseCase(this._addNewUserRepository);

  @override
  Future<String> call(
      {required Uint8List paramsOne,
      required String paramsTwo,
      required String paramsThree}) {
    return _addNewUserRepository.uploadProfileImage(
        photo: paramsOne, userId: paramsTwo, previousImageUrl: paramsThree);
  }
}
