import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class RemoveThisFollowerUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestoreUserRepository _addNewUserRepository;

  RemoveThisFollowerUseCase(this._addNewUserRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _addNewUserRepository.removeThisFollower(paramsOne, paramsTwo);
  }
}
