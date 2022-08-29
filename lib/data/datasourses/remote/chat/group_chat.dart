import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instagram/domain/entities/sender_info.dart';

class FireStoreGroupChat {
  static final _fireStoreChatCollection =
      FirebaseFirestore.instance.collection('chatsOfGroups');

  static Future<Message> createChatForGroups(Message messageInfo) async {
    DocumentReference<Map<String, dynamic>> ref =
        await _fireStoreChatCollection.add(messageInfo.toMap());
    messageInfo.chatOfGroupId = ref.id;

    await _fireStoreChatCollection
        .doc(ref.id)
        .update({"chatOfGroupId": ref.id});
    return messageInfo;
  }

  static Future<Message> sendMessage(
      {bool updateLastMessage = true, required Message message}) async {
    DocumentReference<Map<String, dynamic>> fireChatsCollection =
        _fireStoreChatCollection.doc(message.chatOfGroupId);
    if (updateLastMessage) fireChatsCollection.set(message.toMap());

    CollectionReference<Map<String, dynamic>> fireMessagesCollection =
        fireChatsCollection.collection("messages");

    DocumentReference<Map<String, dynamic>> messageRef =
        await fireMessagesCollection.add(message.toMap());

    message.messageUid = messageRef.id;

    await fireMessagesCollection
        .doc(messageRef.id)
        .update({"messageUid": messageRef.id});
    return message;
  }

  static Future<void> updateLastMessage({
    required String chatOfGroupUid,
    required Message message,
  }) async {
    DocumentReference<Map<String, dynamic>> fireChatsCollection =
        _fireStoreChatCollection.doc(chatOfGroupUid);
    await fireChatsCollection.set(message.toMap());
  }

  static Future<List<SenderInfo>> getSpecificChatsInfo(
      {required List<dynamic> chatsIds}) async {
    List<SenderInfo> allUsers = [];
    for (final chatId in chatsIds) {
      SenderInfo userInfo = await getChatInfo(chatId: chatId);
      allUsers.add(userInfo);
    }
    return allUsers;
  }

  static Future<SenderInfo> getChatInfo({required dynamic chatId}) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _fireStoreChatCollection.doc(chatId);
    DocumentSnapshot<Map<String, dynamic>> snap = await userCollection.get();
    Message messageInfo = Message.fromJson(doc: snap);
    return SenderInfo(lastMessage: messageInfo);
  }

  static Stream<List<Message>> getMessages({required String groupChatUid}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshotsMessages =
        _fireStoreChatCollection
            .doc(groupChatUid)
            .collection("messages")
            .orderBy("datePublished", descending: false)
            .snapshots();
    return snapshotsMessages.map((snapshot) =>
        snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> query) {
          Message messageInfo = Message.fromJson(query: query);
          return messageInfo;
        }).toList());
  }

  static Future<void> deleteMessage(
      {required String chatOfGroupUid, required String messageId}) async {
    await _fireStoreChatCollection
        .doc(chatOfGroupUid)
        .collection("messages")
        .doc(messageId)
        .delete();
  }
}
