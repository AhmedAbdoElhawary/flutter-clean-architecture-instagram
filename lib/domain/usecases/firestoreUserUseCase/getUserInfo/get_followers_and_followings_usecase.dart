import 'package:instegram/data/models/specific_users_info.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../repositories/user_repository.dart';

class GetFollowersAndFollowingsUseCase
    implements UseCaseTwoParams<FollowersAndFollowingsInfo, List<dynamic>,List<dynamic>> {
  final FirestoreUserRepository _fireStoreUserRepository;

  GetFollowersAndFollowingsUseCase(this._fireStoreUserRepository);

  @override
  Future<FollowersAndFollowingsInfo> call({required List<dynamic> paramsOne,required List<dynamic> paramsTwo}) {
    return _fireStoreUserRepository.getFollowersAndFollowingsInfo(followersIds: paramsOne,followingsIds: paramsTwo);
  }
}
