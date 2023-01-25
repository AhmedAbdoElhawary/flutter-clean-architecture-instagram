import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

/// [SenderInfo] it can be sender or receiver
class SenderInfo {
  List<UserPersonalInfo>? receiversInfo;
  List<dynamic>? receiversIds;
  Message? lastMessage;
  bool isThatGroupChat;
  SenderInfo({
    this.receiversInfo,
    this.lastMessage,
    this.receiversIds,
    this.isThatGroupChat = false,
  });
}
