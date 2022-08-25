import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

class Comment {
  String datePublished;
  String theComment;
  String commentUid;
  String postId;
  String whoCommentId;
  UserPersonalInfo? whoCommentInfo;
  List<dynamic> likes;
  String parentCommentId;
  List<dynamic>? replies;
  bool isLoading;
  Comment({
    required this.whoCommentId,
    required this.datePublished,
    required this.theComment,
    this.isLoading = false,
    this.commentUid = "",
    required this.postId,
    this.whoCommentInfo,
    required this.likes,
    this.parentCommentId = '',
    this.replies,
  });

  static Comment fromSnapComment(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Comment(
      datePublished: snapshot.data()?["datePublished"] ?? "",
      theComment: snapshot.data()?["theComment"] ?? "",
      commentUid: snapshot.data()?["commentUid"] ?? "",
      whoCommentId: snapshot.data()?["whoCommentId"] ?? "",
      parentCommentId: snapshot.data()?["parentCommentId"] ?? "",
      postId: snapshot.data()?['postId'] ?? "",
      likes: snapshot.data()?['likes'] ?? [],
      replies: snapshot.data()?["replies"] ?? [],
    );
  }

  Map<String, dynamic> toMapComment() => {
        'datePublished': datePublished,
        "theComment": theComment,
        "commentUid": commentUid,
        "postId": postId,
        "whoCommentId": whoCommentId,
        'likes': likes,
        "replies": replies,
      };

  static Comment fromSnapReply(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Comment(
      datePublished: snapshot.data()?["datePublished"] ?? "",
      theComment: snapshot.data()?["theReply"] ?? "",
      commentUid: snapshot.data()?["replyUid"] ?? "",
      whoCommentId: snapshot.data()?["whoReplyId"] ?? "",
      parentCommentId: snapshot.data()?["parentCommentId"] ?? "",
      postId: snapshot.data()?['postId'] ?? "",
      likes: snapshot.data()?['likes'] ?? [],
    );
  }

  Map<String, dynamic> toMapReply() => {
        'whoReplyId': whoCommentId,
        "datePublished": datePublished,
        "theReply": theComment,
        "parentCommentId": parentCommentId,
        'postId': postId,
        "replyUid": commentUid,
        'likes': likes,
      };
}
