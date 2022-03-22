import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String datePublished;
  String name;
  String profileImageUrl;
  String theComment;
  String commentUid;
  String postId;
  String commentatorId;
  List<String> repliesIds = [];
  List<dynamic> likes = [];

  Comment({
    required this.datePublished,
    required this.name,
    required this.profileImageUrl,
    required this.theComment,
    this.commentUid = '',
    this.postId = '',
    required this.commentatorId,
    List<dynamic>? repliesIds,
    List<dynamic>? likes,
  });
  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      datePublished: snapshot["datePublished"],
      name: snapshot["name"],
      profileImageUrl: snapshot["profileImageUrl"],
      theComment: snapshot["theComment"],
      commentUid: snapshot["commentUid"],
      repliesIds: snapshot["repliesIds"],
      postId: snapshot["postId"],
      commentatorId: snapshot["commentatorId"],
      likes: snapshot['likes'],
    );
  }

  Map<String, dynamic> toMap() => {
        'datePublished': datePublished,
        "name": name,
        "profileImageUrl": profileImageUrl,
        "theComment": theComment,
        "commentUid": commentUid,
        "repliesIds": repliesIds,
        "postId": postId,
        "commentatorId": commentatorId,
        'likes': likes,
      };
}
