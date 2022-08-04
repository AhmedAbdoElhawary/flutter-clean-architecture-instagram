import 'dart:typed_data';

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
  Uint8List? localImage;
  String recordedUrl;
  bool isThatImage;
  bool isThatPost;
  bool multiImages;
  bool isThatVideo;
  String postId;
  String profileImageUrl;
  String userNameOfSharedPost;
  Message({
    this.localImage,
    required this.message,
    required this.blurHash,
    this.multiImages = false,
    required this.receiverId,
    this.isThatPost = false,
    this.isThatVideo = false,
    required this.senderId,
    this.postId = "",
    this.profileImageUrl = "",
    this.userNameOfSharedPost = "",
    this.messageUid = "",
    this.imageUrl = "",
    this.recordedUrl = "",
    required this.isThatImage,
    required this.datePublished,
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
      isThatPost: snap.data()["isThatPost"] ?? false,
      postId: snap.data()["postId"] ?? "",
      profileImageUrl: snap.data()["profileImageUrl"] ?? "",
      userNameOfSharedPost: snap.data()["userNameOfSharedPost"] ?? "",
      multiImages: snap.data()["multiImages"] ?? false,
      isThatVideo: snap.data()["isThatVideo"] ?? false,
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
        "isThatPost": isThatPost,
        "postId": postId,
        "profileImageUrl": profileImageUrl,
        "userNameOfSharedPost": userNameOfSharedPost,
        "multiImages": multiImages,
        "isThatVideo": isThatVideo,
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
        isThatImage,
        isThatPost,
        postId,
        profileImageUrl,
        userNameOfSharedPost,
        multiImages,
        isThatVideo,
      ];
}
