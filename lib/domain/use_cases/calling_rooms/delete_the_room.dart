import 'package:instagram/domain/repositories/calling_rooms_repository.dart';
import 'package:instagram/core/use_case/use_case.dart';

class DeleteTheRoomUseCase
    extends UseCaseTwoParams<void, String, List<dynamic>> {
  final CallingRoomsRepository _callingRoomsRepo;
  DeleteTheRoomUseCase(this._callingRoomsRepo);
  @override
  Future<void> call(
      {required String paramsOne, required List<dynamic> paramsTwo}) async {
    return _callingRoomsRepo.deleteTheRoom(
        channelId: paramsOne, usersIds: paramsTwo);
  }
}
