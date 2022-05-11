import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/user_personal_info.dart';

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

  Comment({
    required this.whoCommentId,
    required this.datePublished,
    required this.theComment,
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
      datePublished: snapshot["datePublished"],
      theComment: snapshot["theComment"],
      commentUid: snapshot["commentUid"],
      postId: snapshot["postId"],
      whoCommentId: snapshot["whoCommentId"],
      likes: snapshot['likes'],
      replies: snapshot["replies"],
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
      datePublished: snapshot["datePublished"],
      theComment: snapshot["theReply"],
      commentUid: snapshot["replyUid"],
      whoCommentId: snapshot["whoReplyId"],
      parentCommentId: snapshot["parentCommentId"],
      postId: snapshot['postId'],
      likes: snapshot['likes'],
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
