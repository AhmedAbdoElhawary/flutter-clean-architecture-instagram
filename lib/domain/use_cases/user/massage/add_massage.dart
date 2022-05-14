import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/massage.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class AddMassageUseCase
    implements UseCaseThreeParams<Massage, Massage, String, String> {
  final FirestoreUserRepository _addPostToUserRepository;

  AddMassageUseCase(this._addPostToUserRepository);

  @override
  Future<Massage> call(
      {required Massage paramsOne,
      required String paramsTwo,
      required String paramsThree}) {
    return _addPostToUserRepository.sendMassage(
        massageInfo: paramsOne,
        pathOfPhoto: paramsTwo,
        pathOfRecorded: paramsThree);
  }
}
