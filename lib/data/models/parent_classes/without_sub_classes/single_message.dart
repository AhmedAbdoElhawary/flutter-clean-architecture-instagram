import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Message extends Equatable {
  String datePublished;
  String message;
  List<dynamic> receiversIds;
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
  bool isThatGroup;
  String chatOfGroupId;
  String postId;
  String senderName;
  String senderProfileImageUrl;
  String profileImageOfSharedPostUrl;
  String userNameOfSharedPost;
  Message({
    this.localImage,
    required this.message,
    required this.blurHash,
    this.multiImages = false,
    required this.receiversIds,
    this.isThatPost = false,
    this.isThatVideo = false,
    this.isThatGroup = false,
    this.chatOfGroupId = "",
    required this.senderId,
    this.postId = "",
    this.senderName = "",
    this.senderProfileImageUrl = "",
    this.profileImageOfSharedPostUrl = "",
    this.userNameOfSharedPost = "",
    this.messageUid = "",
    this.imageUrl = "",
    this.recordedUrl = "",
    required this.isThatImage,
    required this.datePublished,
  });

  static Message fromJson(
      {DocumentSnapshot<Map<String, dynamic>>? doc,
      QueryDocumentSnapshot<Map<String, dynamic>>? query}) {
    dynamic snap = doc ?? query;
    return Message(
      datePublished: snap.data()["datePublished"] ?? "",
      message: snap.data()["message"] ?? "",
      receiversIds: snap.data()["receiversIds"] ?? [],
      senderId: snap.data()["senderId"] ?? "",
      messageUid: snap.data()["messageUid"] ?? "",
      blurHash: snap.data()["blurHash"] ?? "",
      imageUrl: snap.data()["imageUrl"] ?? "",
      senderName: snap.data()["senderName"] ?? "",
      senderProfileImageUrl: snap.data()["senderProfileImageUrl"] ?? "",
      recordedUrl: snap.data()["recordedUrl"] ?? "",
      isThatImage: snap.data()["isThatImage"] ?? false,
      isThatPost: snap.data()["isThatPost"] ?? false,
      postId: snap.data()["postId"] ?? "",
      profileImageOfSharedPostUrl: snap.data()["profileImageUrl"] ?? "",
      userNameOfSharedPost: snap.data()["userNameOfSharedPost"] ?? "",
      multiImages: snap.data()["multiImages"] ?? false,
      isThatVideo: snap.data()["isThatVideo"] ?? false,
      isThatGroup: snap.data()["isThatGroup"] ?? false,
      chatOfGroupId: snap.data()["chatOfGroupId"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "datePublished": datePublished,
        "message": message,
        "receiversIds": receiversIds,
        "senderId": senderId,
        "blurHash": blurHash,
        "imageUrl": imageUrl,
        "recordedUrl": recordedUrl,
        "isThatImage": isThatImage,
        "isThatPost": isThatPost,
        "postId": postId,
        "profileImageUrl": profileImageOfSharedPostUrl,
        "userNameOfSharedPost": userNameOfSharedPost,
        "multiImages": multiImages,
        "isThatVideo": isThatVideo,
        "senderProfileImageUrl": senderProfileImageUrl,
        "senderName": senderName,
        "chatOfGroupId": chatOfGroupId,
        "isThatGroup": isThatGroup,
      };

  @override
  List<Object?> get props => [
        datePublished,
        message,
        receiversIds,
        messageUid,
        senderId,
        blurHash,
        imageUrl,
        recordedUrl,
        isThatImage,
        isThatPost,
        postId,
        profileImageOfSharedPostUrl,
        userNameOfSharedPost,
        multiImages,
        isThatVideo,
        senderName,
        senderProfileImageUrl,
        chatOfGroupId,
        isThatGroup,
      ];
}
