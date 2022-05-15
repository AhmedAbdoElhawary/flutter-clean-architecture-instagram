import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class message extends Equatable {
  String datePublished;
  String message;
  String receiverId;
  String messageUid;
  String senderId;
  String imageUrl;
  String recordedUrl;
  bool isThatImage;

  message({
    required this.datePublished,
    required this.message,
    required this.receiverId,
    required this.senderId,
    this.messageUid = "",
    this.imageUrl = "",
    this.recordedUrl = "",
    required this.isThatImage,
  });

  static message fromJson(QueryDocumentSnapshot<Map<String, dynamic>> snap) {
    return message(
      datePublished: snap.data()["datePublished"] ?? "",
      message: snap.data()["message"] ?? "",
      receiverId: snap.data()["receiverId"] ?? "",
      senderId: snap.data()["senderId"] ?? "",
      messageUid: snap.data()["messageUid"] ?? "",
      imageUrl: snap.data()["imageUrl"] ?? "",
      recordedUrl: snap.data()["recordedUrl"] ?? "",
      isThatImage: snap.data()["isThatImage"] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        "datePublished": datePublished,
        "message": message,
        "receiverId": receiverId,
        "senderId": senderId,
        "imageUrl": imageUrl,
        "recordedUrl": recordedUrl,
        "isThatImage": isThatImage,
      };

  @override
  List<Object?> get props => [
        datePublished,
        message,
        receiverId,
        messageUid,
        senderId,
        imageUrl,
        recordedUrl,
        isThatImage
      ];
}
