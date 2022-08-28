import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/message.dart';

class FireStoreSingleChat {
  static final _fireStoreUserCollection =
      FirebaseFirestore.instance.collection('users');

  static Future<Message> sendMessage({
    required String userId,
    required String chatId,
    required Message message,
  }) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _fireStoreUserCollection.doc(userId);

    DocumentReference<Map<String, dynamic>> fireChatsCollection =
        userCollection.collection("chats").doc(chatId);
    fireChatsCollection.set(message.toMap());

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
    required String userId,
    required String chatId,
    required Message message,
  }) async {
    DocumentReference<Map<String, dynamic>> fireChatsCollection =
        _fireStoreUserCollection
            .doc(myPersonalId)
            .collection("chats")
            .doc(chatId != myPersonalId ? chatId : userId);
    await fireChatsCollection.set(message.toMap());
  }

  static Stream<List<Message>> getMessages({required String receiverId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshotsMessages =
        _fireStoreUserCollection
            .doc(myPersonalId)
            .collection("chats")
            .doc(receiverId)
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
      {required String userId,
      required String chatId,
      required String messageId}) async {
    await _fireStoreUserCollection
        .doc(userId)
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }
}
