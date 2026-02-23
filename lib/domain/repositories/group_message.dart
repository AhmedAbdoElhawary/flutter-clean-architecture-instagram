import 'dart:io';
import 'dart:typed_data';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';

abstract class FireStoreGroupMessageRepository {
  Future<Message> createChatForGroups(Message messageInfo);

  Future<Message> sendMessage(
      {required Message messageInfo,
      Uint8List? pathOfPhoto,
      required File? recordFile});

  Stream<List<Message>> getMessages({required String groupChatUid});

  Future<void> deleteMessage(
      {required Message messageInfo,
      required String chatOfGroupUid,
      Message? replacedMessage});
}
