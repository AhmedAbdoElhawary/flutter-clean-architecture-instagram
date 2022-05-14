import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Massage extends Equatable {
  String datePublished;
  String massage;
  String receiverId;
  String massageUid;
  String senderId;
  String imageUrl;
  String recordedUrl;
  bool isThatImage;

  Massage({
    required this.datePublished,
    required this.massage,
    required this.receiverId,
    required this.senderId,
    this.massageUid = "",
    this.imageUrl = "",
    this.recordedUrl = "",
    required this.isThatImage,
  });

  static Massage fromJson(DocumentSnapshot snap) {
    return Massage(
      datePublished: snap["datePublished"] ?? '',
      massage: snap["massage"] ?? '',
      receiverId: snap["receiverId"] ?? '',
      senderId: snap["senderId"] ?? '',
      massageUid: snap["massageUid"] ?? '',
      imageUrl: snap["imageUrl"] ?? '',
      recordedUrl: snap["recordedUrl"] ?? '',
      isThatImage: snap["isThatImage"] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        "datePublished": datePublished,
        "massage": massage,
        "receiverId": receiverId,
        "senderId": senderId,
        "imageUrl": imageUrl,
        "recordedUrl": recordedUrl,
        "isThatImage": isThatImage,
      };

  @override
  List<Object?> get props => [
        datePublished,
        massage,
        receiverId,
        massageUid,
        senderId,
        imageUrl,
        recordedUrl
      ];
}
