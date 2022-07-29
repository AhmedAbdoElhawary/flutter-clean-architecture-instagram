import 'package:instagram/data/models/message.dart';
import 'package:instagram/data/models/user_personal_info.dart';

/// it can be sender or receiver
class SenderInfo {
  UserPersonalInfo? userInfo;
  Message? lastMessage;

  SenderInfo({
    this.userInfo,
    this.lastMessage,
  });
}
