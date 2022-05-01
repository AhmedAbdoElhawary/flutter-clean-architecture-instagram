import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:instegram/domain/repositories/user_repository.dart';

class SearchAboutUserUseCase
    implements StreamUseCase<List<UserPersonalInfo>, String> {
  final FirestoreUserRepository _addPostToUserRepository;

  SearchAboutUserUseCase(this._addPostToUserRepository);

  @override
  Stream<List<UserPersonalInfo>> call({required String params}) {
    return _addPostToUserRepository.searchAboutUser(name: params);
  }
}
