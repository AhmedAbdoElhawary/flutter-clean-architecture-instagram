import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/core/usecase/usecase.dart';
import 'package:instegram/domain/repositories/user_repository.dart';

class GetMassagesUseCase implements StreamUseCase<QuerySnapshot<Map<String, dynamic>>, String> {
  final FirestoreUserRepository _addPostToUserRepository;

  GetMassagesUseCase(this._addPostToUserRepository);

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> call({required String params}) {
    return _addPostToUserRepository.getMassages(receiverId: params);
  }
}
