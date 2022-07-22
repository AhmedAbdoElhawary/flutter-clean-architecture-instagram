import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class NotificationCheck extends Equatable {
  String receiverId;
  String senderId;
  bool isThatPost;
  bool isThatLike;
  String postId;

  NotificationCheck({
    required this.receiverId,
    required this.senderId,
    this.postId = "",
    this.isThatLike = true,
    this.isThatPost = true,
  });

  @override
  List<Object?> get props => [
        receiverId,
        senderId,
        postId,
        isThatLike,
        isThatPost,
      ];
}
