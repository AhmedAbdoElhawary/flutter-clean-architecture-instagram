import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/parent_post.dart';
import 'package:instagram/data/models/user_personal_info.dart';

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
      {required DocumentSnapshot<Map<String, dynamic>> docSnap}) {
    return Story(
      caption: docSnap.data()!["caption"] ?? "",
      datePublished: docSnap.data()!["datePublished"] ?? "",
      publisherId: docSnap.data()!["publisherId"] ?? "",
      likes: docSnap.data()!["likes"] ?? [],
      comments: docSnap.data()!["comments"] ?? [],
      storyUid: docSnap.data()!["storyUid"] ?? "",
      storyUrl: docSnap.data()!["storyUrl"] ?? "",
      isThatImage: docSnap.data()!["isThatImage"] ?? true,
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
