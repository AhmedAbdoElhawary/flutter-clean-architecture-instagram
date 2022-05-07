import 'package:instegram/data/models/post.dart';
import 'package:instegram/domain/repositories/post/post_repository.dart';
import '../../../../core/usecase/usecase.dart';

class GetPostsInfoUseCase
    implements UseCaseTwoParams<List<Post>, List<dynamic>, int> {
  final FirestorePostRepository _getPostRepository;

  GetPostsInfoUseCase(this._getPostRepository);

  @override
  Future<List<Post>> call(
      {required List<dynamic> paramsOne, required int paramsTwo}) {
    return _getPostRepository.getPostsInfo(
        postsIds: paramsOne, lengthOfCurrentList: paramsTwo);
  }
}
