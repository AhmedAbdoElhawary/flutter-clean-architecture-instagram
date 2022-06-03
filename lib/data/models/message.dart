import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Message extends Equatable {
  String datePublished;
  String message;
  String receiverId;
  String messageUid;
  String blurHash;
  String senderId;
  String imageUrl;
  String recordedUrl;
  bool isThatImage;

  Message({
    required this.datePublished,
    required this.message,
    required this.blurHash,
    required this.receiverId,
    required this.senderId,
    this.messageUid = "",
    this.imageUrl = "",
    this.recordedUrl = "",
    required this.isThatImage,
  });

  static Message fromJson(QueryDocumentSnapshot<Map<String, dynamic>> snap) {
    return Message(
      datePublished: snap.data()["datePublished"] ?? "",
      message: snap.data()["message"] ?? "",
      receiverId: snap.data()["receiverId"] ?? "",
      senderId: snap.data()["senderId"] ?? "",
      messageUid: snap.data()["messageUid"] ?? "",
      blurHash: snap.data()["blurHash"] ?? "",
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
        "blurHash": blurHash,
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
        blurHash,
        imageUrl,
        recordedUrl,
        isThatImage
      ];
}
