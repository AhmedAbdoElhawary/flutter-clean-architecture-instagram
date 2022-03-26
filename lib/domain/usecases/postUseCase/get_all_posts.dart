import 'package:instegram/data/models/post.dart';
import 'package:instegram/domain/repositories/post_repository.dart';
import '../../../core/usecase/usecase.dart';

class GetAllPostsInfoUseCase implements UseCase<List<Post>, void> {
  final FirestorePostRepository _getPostRepository;

  GetAllPostsInfoUseCase(this._getPostRepository);

  @override
  Future<List<Post>> call({required void params}) {
    return _getPostRepository.getAllPostsInfo();
  }
}
