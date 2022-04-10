import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/domain/repositories/post_repository.dart';

class GetAllCommentsUseCase implements UseCase<List<Comment>, String> {
  final FirestorePostRepository _getAllCommentsRepository;

  GetAllCommentsUseCase(this._getAllCommentsRepository);

  @override
  Future<List<Comment>> call({required String params}) {
    return _getAllCommentsRepository.getCommentsOfThisPost(postId:params );
  }
}
