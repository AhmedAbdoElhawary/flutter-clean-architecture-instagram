import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/domain/repositories/calling_rooms_repository.dart';
import 'package:instagram/core/use_case/use_case.dart';

class CreateCallingRoomUseCase
    extends UseCaseTwoParams<String, UserPersonalInfo, List<UserPersonalInfo>> {
  final CallingRoomsRepository _callingRoomsRepo;
  CreateCallingRoomUseCase(this._callingRoomsRepo);
  @override
  Future<String> call(
      {required UserPersonalInfo paramsOne,
      required List<UserPersonalInfo> paramsTwo}) async {
    return await _callingRoomsRepo.createCallingRoom(
        myPersonalInfo: paramsOne, callThoseUsersInfo: paramsTwo);
  }
}
