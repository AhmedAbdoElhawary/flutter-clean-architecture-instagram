import 'package:instagram/domain/entities/calling_status.dart';
import 'package:instagram/domain/repositories/calling_rooms_repository.dart';
import 'package:instagram/core/use_case/use_case.dart';

class GetUsersInfoInRoomUseCase
    extends UseCase<List<UserInfoInCallingRoom>, String> {
  final CallingRoomsRepository _callingRoomsRepo;
  GetUsersInfoInRoomUseCase(this._callingRoomsRepo);
  @override
  Future<List<UserInfoInCallingRoom>> call({required String params}) {
    return _callingRoomsRepo.getUsersInfoInThisRoom(channelId: params);
  }
}
