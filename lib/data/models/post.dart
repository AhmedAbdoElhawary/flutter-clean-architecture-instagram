import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/parent_post.dart';
import 'package:instagram/data/models/user_personal_info.dart';

class Post extends ParentPost {
  String postUrl;
  String postUid;
  double aspectRatio;
  Post({
    required String datePublished,
    required String publisherId,
    UserPersonalInfo? publisherInfo,
    this.postUid = "",
    this.postUrl = "",
    required this.aspectRatio,
    String caption = "",
    required List<dynamic> comments,
    required List<dynamic> likes,
    bool isThatImage = true,
  }) : super(
            datePublished: datePublished,
            likes: likes,
            comments: comments,
            publisherId: publisherId,
            isThatImage: isThatImage,
            caption: caption,
            publisherInfo: publisherInfo);

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
      aspectRatio: snap["aspectRatio"],
      postUrl: snap["postUrl"],
      isThatImage: snap["isThatImage"],
    );
  }

  Map<String, dynamic> toMap() => {
        'caption': caption,
        "datePublished": datePublished,
        "publisherId": publisherId,
        'comments': comments,
        'aspectRatio': aspectRatio,
        'likes': likes,
        'postUid': postUid,
        "postUrl": postUrl,
        "isThatImage": isThatImage,
      };
}
