import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/massage.dart';

class FireStoreMassage {
  static final _fireStoreUserCollection =
      FirebaseFirestore.instance.collection('users');

  static Future<Massage> sendMassage({
    required String userId,
    required String chatId,
    required Massage massage,
  }) async {
    CollectionReference<Map<String, dynamic>> _fireMassagesCollection =
        _fireStoreUserCollection
            .doc(userId)
            .collection("chats")
            .doc(chatId)
            .collection("massages");

    DocumentReference<Map<String, dynamic>> massageRef =
        await _fireMassagesCollection.add(massage.toMap());

    massage.massageUid = massageRef.id;

    await _fireMassagesCollection
        .doc(massageRef.id)
        .update({"massageUid": massageRef.id});
    return massage;
  }

  static Stream<List<Massage>> getMassages({required String receiverId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> _snapshotsMassages =
        _fireStoreUserCollection
            .doc(myPersonalId)
            .collection("chats")
            .doc(receiverId)
            .collection("massages")
            .orderBy("datePublished", descending: false)
            .snapshots();
    return _snapshotsMassages.map((snapshot) =>
        snapshot.docs.map((doc) => Massage.fromJson(doc)).toList());
  }
  static Future<void> deleteMassage(
      {required String userId,
      required String chatId,
      required String massageId}) async {
    await _fireStoreUserCollection
        .doc(userId)
        .collection("chats")
        .doc(chatId)
        .collection("massages")
        .doc(massageId)
        .delete();
  }
}
