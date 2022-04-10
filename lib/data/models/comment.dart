
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/models/user_personal_info.dart';
class Comment {
  String datePublished;
  String theComment;
  String commentUid;
  String postId;
  // bool isThisReply;
  String commentatorId;
  UserPersonalInfo? commentatorInfo;
  List<dynamic>? repliesIds;
  List<dynamic>? likes;

  Comment({
    required this.commentatorId,
    required this.datePublished,
    required this.theComment,
    // required this.isThisReply,
    this.commentUid = "",
    required this.postId ,
    this.commentatorInfo,
    this.repliesIds,
    this.likes,
  });


  static Comment fromSnap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Comment(
      datePublished: snapshot["datePublished"],
      theComment: snapshot["theComment"],
      commentUid: snapshot["commentUid"],
      repliesIds: snapshot["repliesIds"],
      postId: snapshot["postId"],
      // isThisReply: snapshot["isThisReply"],
      commentatorId: snapshot["commentatorId"],
      likes: snapshot['likes'],
    );
  }

  Map<String, dynamic> toMap() => {
        'datePublished': datePublished,
        "theComment": theComment,
        "commentUid": commentUid,
        "repliesIds": repliesIds,
        "postId": postId,
        // "isThisReply": isThisReply,
        "commentatorId": commentatorId,
        'likes': likes,
      };
}
