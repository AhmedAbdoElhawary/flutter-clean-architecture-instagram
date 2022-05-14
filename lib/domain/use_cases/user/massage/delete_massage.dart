import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/massage.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class DeleteMassageUseCase implements UseCase<void, Massage> {
  final FirestoreUserRepository _addPostToUserRepository;

  DeleteMassageUseCase(this._addPostToUserRepository);

  @override
  Future<void> call({required Massage params}) {
    return _addPostToUserRepository.deleteMassage(massageInfo: params);
  }
}
