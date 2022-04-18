import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/massage.dart';
import 'package:instegram/domain/repositories/user_repository.dart';

class AddMassageUseCase implements UseCaseTwoParams<Massage, Massage,String> {
  final FirestoreUserRepository _addPostToUserRepository;

  AddMassageUseCase(this._addPostToUserRepository);

  @override
  Future<Massage> call({required Massage paramsOne,required String paramsTwo,}) {
    return _addPostToUserRepository.sendMassage(massageInfo: paramsOne,pathOfPhoto:paramsTwo );
  }
}
