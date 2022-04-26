import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/post.dart';
import 'package:instegram/domain/repositories/post/comment/comment_repository.dart';

class GetSpecificCommentsUseCase
    implements StreamUseCase<Post, String> {
  final FirestoreCommentRepository _getAllCommentsRepository;

  GetSpecificCommentsUseCase(this._getAllCommentsRepository);

  @override
  Stream<Post> call(
      {required String params}) {
    return _getAllCommentsRepository.getSpecificComments(postId: params);
  }
}
