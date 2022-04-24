import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/massage.dart';
import 'package:instegram/domain/repositories/user_repository.dart';

class GetMassagesUseCase implements StreamUseCase<List<Massage>, String> {
  final FirestoreUserRepository _addPostToUserRepository;

  GetMassagesUseCase(this._addPostToUserRepository);

  @override
  Stream<List<Massage>> call({required String params}) {
    return _addPostToUserRepository.getMassages(receiverId: params);
  }
}
