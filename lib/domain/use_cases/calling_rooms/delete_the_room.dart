import 'package:instagram/domain/repositories/calling_rooms_repository.dart';
import 'package:instagram/core/use_case/use_case.dart';

class DeleteTheRoomUseCase extends UseCaseTwoParams<void, String, String> {
  final CallingRoomsRepository _callingRoomsRepo;
  DeleteTheRoomUseCase(this._callingRoomsRepo);
  @override
  Future<void> call(
      {required String paramsOne, required String paramsTwo}) async {
    return _callingRoomsRepo.deleteTheRoom(
        channelId: paramsOne, userId: paramsTwo);
  }
}
