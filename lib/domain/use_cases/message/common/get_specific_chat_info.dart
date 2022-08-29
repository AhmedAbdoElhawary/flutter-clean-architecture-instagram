import 'package:instagram/core/use_case/use_case.dart';
import 'package:instagram/domain/entities/sender_info.dart';
import 'package:instagram/domain/repositories/user_repository.dart';

class GetSpecificChatInfo
    implements UseCaseTwoParams<SenderInfo, String, bool> {
  final FirestoreUserRepository _getSpecificChatInfoRepository;

  GetSpecificChatInfo(this._getSpecificChatInfoRepository);

  @override
  Future<SenderInfo> call(
      {required String paramsOne, required bool paramsTwo}) {
    return _getSpecificChatInfoRepository.getSpecificChatInfo(
        chatUid: paramsOne, isThatGroup: paramsTwo);
  }
}
