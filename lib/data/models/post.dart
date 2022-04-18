import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/models/user_personal_info.dart';

class Post {
  String datePublished;
  String caption;
  String postUrl;
  String publisherId;
  String postUid;
  List<dynamic> likes;
  List<dynamic> comments;
  UserPersonalInfo? publisherInfo;
  bool isThatImage;

  Post({
    required this.datePublished,
    required this.publisherId,
    this.publisherInfo,
    this.postUid = "",
    this.postUrl = "",
    this.caption = "",
    required this.comments,
    required this.likes,
    this.isThatImage = true,
  });

  static Post fromSnap(
      {QueryDocumentSnapshot<Map<String, dynamic>>? querySnap,
      DocumentSnapshot<Map<String, dynamic>>? docSnap}) {
    dynamic snap = querySnap ?? docSnap;
    return Post(
      caption: snap["caption"],
      datePublished: snap["datePublished"],
      publisherId: snap["publisherId"],
      likes: snap["likes"],
      comments: snap["comments"],
      postUid: snap["postUid"],
      postUrl: snap["postUrl"],
      isThatImage: snap["isThatImage"],
    );
  }

  Map<String, dynamic> toMap() => {
        'caption': caption,
        "datePublished": datePublished,
        "publisherId": publisherId,
        'comments': comments,
        'likes': likes,
        'postUid': postUid,
        "postUrl": postUrl,
        "isThatImage": isThatImage,
      };
}
