import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/models/parent_post.dart';
import 'package:instegram/data/models/user_personal_info.dart';

class Story extends ParentPost {
  String storyUrl;
  String storyUid;
  Story({
    required String datePublished,
    required String publisherId,
    UserPersonalInfo? publisherInfo,
    this.storyUid = "",
    this.storyUrl = "",
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

  static Story fromSnap(
      {QueryDocumentSnapshot<Map<String, dynamic>>? querySnap,
      DocumentSnapshot<Map<String, dynamic>>? docSnap}) {
    dynamic snap = querySnap ?? docSnap;
    return Story(
      caption: snap["caption"],
      datePublished: snap["datePublished"],
      publisherId: snap["publisherId"],
      likes: snap["likes"],
      comments: snap["comments"],
      storyUid: snap["storyUid"],
      storyUrl: snap["storyUrl"],
      isThatImage: snap["isThatImage"],
    );
  }

  Map<String, dynamic> toMap() => {
        'caption': caption,
        "datePublished": datePublished,
        "publisherId": publisherId,
        'comments': comments,
        'likes': likes,
        'storyUid': storyUid,
        "storyUrl": storyUrl,
        "isThatImage": isThatImage,
      };
}
