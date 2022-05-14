import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class SearchAboutUserUseCase
    implements StreamUseCase<List<UserPersonalInfo>, String> {
  final FirestoreUserRepository _addPostToUserRepository;

  SearchAboutUserUseCase(this._addPostToUserRepository);

  @override
  Stream<List<UserPersonalInfo>> call({required String params}) {
    return _addPostToUserRepository.searchAboutUser(name: params);
  }
}
