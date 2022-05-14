import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/massage.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class GetMassagesUseCase implements StreamUseCase<List<Massage>, String> {
  final FirestoreUserRepository _addPostToUserRepository;

  GetMassagesUseCase(this._addPostToUserRepository);

  @override
  Stream<List<Massage>> call({required String params}) {
    return _addPostToUserRepository.getMassages(receiverId: params);
  }
}
