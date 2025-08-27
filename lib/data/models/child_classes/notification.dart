
import 'package:instagram/domain/entities/notification_check.dart';

// ignore: must_be_immutable
class CustomNotification extends NotificationCheck {
  String notificationUid;
  String text;

  String time;
  String personalUserName;
  String postImageUrl;
  String personalProfileImageUrl;
  String senderName;
  CustomNotification({
    required this.text,
    required super.senderId,
    super.postId,
    required this.time,
    required super.receiverId,
    super.isThatPost,
    super.isThatLike,
    this.postImageUrl = "",
    required this.personalUserName,
    this.notificationUid = "",
    required this.personalProfileImageUrl,
    required this.senderName,
  });
  static CustomNotification fromJson(Map<String, dynamic>? snap) {
    return CustomNotification(
      notificationUid: snap?["notificationUid"] ?? "",
      text: snap?["text"] ?? "",
      time: snap?["time"] ?? "",
      receiverId: snap?["receiverId"] ?? "",
      personalUserName: snap?["personalUserName"] ?? "",
      postImageUrl: snap?["postImageUrl"] ?? "",
      personalProfileImageUrl: snap?["personalProfileImageUrl"] ?? "",
      isThatPost: snap?["isThatPost"] ?? true,
      postId: snap?["postId"] ?? "",
      senderId: snap?["senderId"] ?? "",
      isThatLike: snap?["isThatLike"] ?? true,
      senderName: snap?["senderName"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "text": text,
        "time": time,
        "receiverId": receiverId,
        "personalUserName": personalUserName,
        "postImageUrl": postImageUrl,
        "isThatPost": isThatPost,
        "personalProfileImageUrl": personalProfileImageUrl,
        "postId": postId,
        "senderId": senderId,
        "isThatLike": isThatLike,
        "senderName": senderName,
      };
}
