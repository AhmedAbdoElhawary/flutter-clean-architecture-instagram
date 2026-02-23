import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

// ignore: must_be_immutable
class Message extends Equatable {
  String datePublished;
  String message;
  List<dynamic> receiversIds;
  String messageUid;
  String blurHash;
  String senderId;
  UserPersonalInfo? senderInfo;
  String imageUrl;
  Uint8List? localImage;
  String recordedUrl;
  bool isThatImage;
  bool isThatPost;
  bool isThatRecord;
  bool multiImages;
  bool isThatVideo;
  bool isThatGroup;
  String chatOfGroupId;
  String sharedPostId;
  String ownerOfSharedPostId;
  int lengthOfRecord;
  Message({
    this.localImage,
    required this.message,
    required this.blurHash,
    this.multiImages = false,
    required this.receiversIds,
    this.isThatPost = false,
    this.isThatVideo = false,
    this.isThatGroup = false,
    this.isThatRecord = false,
    this.chatOfGroupId = "",
    required this.senderId,
    this.sharedPostId = "",
    this.ownerOfSharedPostId = "",
    this.messageUid = "",
    this.imageUrl = "",
    this.recordedUrl = "",
    this.senderInfo,
    required this.isThatImage,
    required this.datePublished,
    this.lengthOfRecord = 0,
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
      ownerOfSharedPostId: snap.data()["ownerOfSharedPostId"] ?? "",
      recordedUrl: snap.data()["recordedUrl"] ?? "",
      isThatImage: snap.data()["isThatImage"] ?? false,
      isThatPost: snap.data()["isThatPost"] ?? false,
      sharedPostId: snap.data()["postId"] ?? "",
      multiImages: snap.data()["multiImages"] ?? false,
      isThatVideo: snap.data()["isThatVideo"] ?? false,
      isThatGroup: snap.data()["isThatGroup"] ?? false,
      isThatRecord: snap.data()["isThatRecord"] ?? false,
      chatOfGroupId: snap.data()["chatOfGroupId"] ?? "",
      lengthOfRecord: snap.data()["lengthOfRecord"] ?? 0,
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
        "postId": sharedPostId,
        "ownerOfSharedPostId": ownerOfSharedPostId,
        "multiImages": multiImages,
        "isThatVideo": isThatVideo,
        "chatOfGroupId": chatOfGroupId,
        "isThatGroup": isThatGroup,
        "isThatRecord": isThatRecord,
        "lengthOfRecord": lengthOfRecord,
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
        sharedPostId,
        ownerOfSharedPostId,
        multiImages,
        isThatVideo,
        chatOfGroupId,
        isThatGroup,
        isThatRecord,
        lengthOfRecord,
      ];
}
