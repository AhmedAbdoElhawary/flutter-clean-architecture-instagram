import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/data/models/comment.dart';
import 'package:instegram/domain/repositories/post/comment/comment_repository.dart';

class GetCommentUseCase implements UseCase<List<Comment>, List<dynamic>> {
  final FirestoreCommentRepository _getCommentRepository;

  GetCommentUseCase(this._getCommentRepository);

  @override
  Future<List<Comment>> call({required List<dynamic> params}) {
    return _getCommentRepository.getSpecificComments(commentsIds: params);
  }
}
