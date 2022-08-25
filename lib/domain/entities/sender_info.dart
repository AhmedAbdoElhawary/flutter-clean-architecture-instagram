import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

/// [SenderInfo] it can be sender or receiver
class SenderInfo {
  List<UserPersonalInfo>? receiversInfo;

  Message? lastMessage;
  bool isThatGroupChat;
  SenderInfo({
    this.receiversInfo,
    this.lastMessage,
    this.isThatGroupChat = false,
  });
}
