import 'package:instegram/data/models/specific_users_info.dart';
import '../../../core/usecase/usecase.dart';
import '../../repositories/user_repository.dart';

class GetSpecificUsersUseCase
    implements UseCaseTwoParams<SpecificUsersInfo, List<dynamic>,List<dynamic>> {
  final FirestoreUserRepository _fireStoreUserRepository;

  GetSpecificUsersUseCase(this._fireStoreUserRepository);

  @override
  Future<SpecificUsersInfo> call({required List<dynamic> paramsOne,required List<dynamic> paramsTwo}) {
    return _fireStoreUserRepository.getSpecificUsersInfo(followersIds: paramsOne,followingsIds: paramsTwo);
  }
}
