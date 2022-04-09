import 'package:instegram/domain/repositories/post_repository.dart';
import '../../../core/usecase/usecase.dart';

class GetSpecificUsersPostsUseCase implements UseCase<List, List<dynamic>> {
  final FirestorePostRepository _getSpecificUsersPostsRepository;

  GetSpecificUsersPostsUseCase(this._getSpecificUsersPostsRepository);

  @override
  Future<List> call({required List<dynamic> params}) {
    return _getSpecificUsersPostsRepository.getSpecificUsersPosts(params);
  }
}
