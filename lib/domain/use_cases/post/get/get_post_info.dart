import 'package:instagram/data/models/post.dart';
import 'package:instagram/domain/repositories/post/post_repository.dart';
import 'package:instagram/core/use_case/use_case.dart';

class GetPostsInfoUseCase
    implements UseCaseThreeParams<List<Post>, List<dynamic>,String, int> {
  final FirestorePostRepository _getPostRepository;

  GetPostsInfoUseCase(this._getPostRepository);

  @override
  Future<List<Post>> call(
      {required List<dynamic> paramsOne,  required String paramsTwo,required int paramsThree}) {
    return _getPostRepository.getPostsInfo(
        postsIds: paramsOne,userId:paramsTwo, lengthOfCurrentList: paramsThree);
  }
}
