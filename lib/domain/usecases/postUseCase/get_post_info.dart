import 'package:instegram/data/models/post.dart';
import 'package:instegram/domain/repositories/post_repository.dart';
import '../../../core/usecase/usecase.dart';

class GetPostsInfoUseCase implements UseCase<List<Post>, List<dynamic>> {
  final FirestorePostRepository _getPostRepository;

  GetPostsInfoUseCase(this._getPostRepository);

  @override
  Future<List<Post>> call({required List<dynamic> params}) {
    return _getPostRepository.getPostsInfo(params);
  }
}
