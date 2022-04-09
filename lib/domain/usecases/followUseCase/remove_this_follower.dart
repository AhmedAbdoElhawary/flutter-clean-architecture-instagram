import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/domain/repositories/user_repository.dart';

class RemoveThisFollowerUseCase implements UseCaseTwoParams<void,String,String > {
  final FirestoreUserRepository _addNewUserRepository;

  RemoveThisFollowerUseCase(this._addNewUserRepository);

  @override
  Future<void> call({required String paramsOne,required String paramsTwo}) {
    return _addNewUserRepository.removeThisFollower(paramsOne,paramsTwo);
  }
}
