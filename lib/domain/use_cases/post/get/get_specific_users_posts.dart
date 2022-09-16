import 'package:instagram/domain/repositories/post/post_repository.dart';
import 'package:instagram/core/use_case/use_case.dart';

class GetSpecificUsersPostsUseCase implements UseCase<List, List<dynamic>> {
  final FireStorePostRepository _getSpecificUsersPostsRepository;

  GetSpecificUsersPostsUseCase(this._getSpecificUsersPostsRepository);

  @override
  Future<List> call({required List<dynamic> params}) {
    return _getSpecificUsersPostsRepository.getSpecificUsersPosts(params);
  }
}
