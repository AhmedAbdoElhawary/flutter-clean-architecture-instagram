import 'package:instegram/data/models/post.dart';
import 'package:instegram/domain/repositories/post_repository.dart';
import '../../../core/usecase/usecase.dart';

class GetPostInfoUseCase implements UseCase<List<Post>, List<String>> {
  final FirestorePostRepository _getPostRepository;

  GetPostInfoUseCase(this._getPostRepository);

  @override
  Future<List<Post>> call({required List<String> params}) {
    return _getPostRepository.getPostInfo(params);
  }
}
