import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/massage.dart';
import 'package:instegram/domain/repositories/user_repository.dart';

class AddMassageUseCase implements UseCase<Massage, Massage> {
  final FirestoreUserRepository _addPostToUserRepository;

  AddMassageUseCase(this._addPostToUserRepository);

  @override
  Future<Massage> call({required Massage params}) {
    return _addPostToUserRepository.sendMassage(massageInfo: params);
  }
}
