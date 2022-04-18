import 'package:cloud_firestore/cloud_firestore.dart';

class Massage {
  String datePublished;
  String massage;
  String receiverId;
  String massageUid;
  String senderId;
  String imageUrl;

  Massage({
    required this.datePublished,
    required this.massage,
    required this.receiverId,
    required this.senderId,
    this.massageUid = "",
    this.imageUrl = "",
  });

  static Massage fromJson(DocumentSnapshot snap) {
    return Massage(
      datePublished: snap["datePublished"],
      massage: snap["massage"],
      receiverId: snap["receiverId"],
      senderId: snap["senderId"],
      massageUid: snap["massageUid"],
      imageUrl: snap["imageUrl"],
    );
  }

  Map<String, dynamic> toMap() => {
        "datePublished": datePublished,
        "massage": massage,
        "receiverId": receiverId,
        "senderId": senderId,
        "imageUrl": imageUrl,
      };
}
