import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/models/user_personal_info.dart';

class Comment {
  String datePublished;
  String theComment;
  String commentUid;
  String? postId;
  String commentatorId;
  UserPersonalInfo? commentatorInfo;
  int? numbersOfReplies;
  List<dynamic> likes;

  bool isThatReply;
  String? idOfPersonIReplyOnThem;
  UserPersonalInfo? infoOfPersonIReplyOnThem;

  Comment({
    required this.commentatorId,
    required this.datePublished,
    required this.theComment,
    this.numbersOfReplies,
    this.commentUid = "",
    this.postId,
    this.commentatorInfo,
    required this.likes,
    this.isThatReply = false,
    this.idOfPersonIReplyOnThem,
  });

  static Comment fromSnapComment(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Comment(
      datePublished: snapshot["datePublished"],
      theComment: snapshot["theComment"],
      commentUid: snapshot["commentUid"],
      postId: snapshot["postId"],
      numbersOfReplies: snapshot["numbersOfReplies"],
      commentatorId: snapshot["commentatorId"],
      likes: snapshot['likes'],
    );
  }

  Map<String, dynamic> toMapComment() => {
        'datePublished': datePublished,
        "theComment": theComment,
        "commentUid": commentUid,
        "postId": postId,
        "numbersOfReplies": numbersOfReplies,
        "commentatorId": commentatorId,
        'likes': likes,
      };

  static Comment fromSnapReply(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Comment(
      commentUid: snapshot["commentUid"],
      commentatorId: snapshot["commentatorId"],
      datePublished: snapshot["datePublished"],
      idOfPersonIReplyOnThem: snapshot["idOfPersonIReplyOnThem"],
      theComment: snapshot["theComment"],
      likes: snapshot['likes'],
      isThatReply: true,
    );
  }

  Map<String, dynamic> toMapReply() => {
        'commentUid': commentUid,
        "commentatorId": commentatorId,
        "datePublished": datePublished,
        "idOfPersonIReplyOnThem": idOfPersonIReplyOnThem,
        "theComment": theComment,
        'likes': likes,
      };
}
