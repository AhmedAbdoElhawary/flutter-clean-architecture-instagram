import 'package:instagram/domain/repositories/calling_rooms_repository.dart';
import 'package:instagram/core/use_case/use_case.dart';

class CancelJoiningToRoomUseCase extends UseCase<void, String> {
  final CallingRoomsRepository _cancelJoiningToRoomRepo;
  CancelJoiningToRoomUseCase(this._cancelJoiningToRoomRepo);
  @override
  Future<void> call({required String params}) async {
    return await _cancelJoiningToRoomRepo.cancelJoiningToRoom(params);
  }
}
