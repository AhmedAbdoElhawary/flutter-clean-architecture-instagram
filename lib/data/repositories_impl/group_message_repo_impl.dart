import 'dart:io';

import 'dart:typed_data';

import 'package:instagram/data/data_sources/remote/chat/group_chat.dart';
import 'package:instagram/data/data_sources/remote/firebase_storage.dart';
import 'package:instagram/data/data_sources/remote/user/firestore_user_info.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/domain/repositories/group_message.dart';

class FirebaseGroupMessageRepoImpl implements FireStoreGroupMessageRepository {
  @override
  Future<Message> createChatForGroups(Message messageInfo) async {
    try {
      Message messageDetails =
          await FireStoreGroupChat.createChatForGroups(messageInfo);
      await FireStoreUser.updateChatsOfGroups(messageInfo: messageDetails);
      return messageDetails;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<Message> sendMessage(
      {required Message messageInfo,
      Uint8List? pathOfPhoto,
      required File? recordFile}) async {
    try {
      if (pathOfPhoto != null) {
        String imageUrl = await FirebaseStoragePost.uploadData(
            data: pathOfPhoto, folderName: "messagesFiles");
        messageInfo.imageUrl = imageUrl;
      }
      if (recordFile != null) {
        String recordedUrl = await FirebaseStoragePost.uploadFile(
            folderName: "messagesFiles", postFile: recordFile);
        messageInfo.recordedUrl = recordedUrl;
      }
      bool updateLastMessage = true;
      if (messageInfo.chatOfGroupId.isEmpty) {
        Message newMessageInfo = await createChatForGroups(messageInfo);
        messageInfo = newMessageInfo;
        updateLastMessage = false;
      }
      Message myMessageInfo = await FireStoreGroupChat.sendMessage(
          updateLastMessage: updateLastMessage, message: messageInfo);

      for (final userId in messageInfo.receiversIds) {
        await FireStoreUser.sendNotification(
            userId: userId, message: messageInfo);
      }

      return myMessageInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<Message>> getMessages({required String groupChatUid}) =>
      FireStoreGroupChat.getMessages(groupChatUid: groupChatUid);

  @override
  Future<void> deleteMessage({
    required Message messageInfo,
    required String chatOfGroupUid,
    Message? replacedMessage,
  }) async {
    try {
      await FireStoreGroupChat.deleteMessage(
          chatOfGroupUid: chatOfGroupUid, messageId: messageInfo.messageUid);
      if (replacedMessage != null) {
        await FireStoreGroupChat.updateLastMessage(
            chatOfGroupUid: chatOfGroupUid, message: replacedMessage);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
