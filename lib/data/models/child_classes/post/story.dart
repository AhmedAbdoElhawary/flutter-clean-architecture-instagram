import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/parent_classes/post/parent_post.dart';

class Story extends ParentPost {
  String storyUrl;
  String storyUid;
  Story({
    required super.datePublished,
    required super.publisherId,
    super.publisherInfo,
    this.storyUid = "",
    this.storyUrl = "",
    super.caption,
    required super.comments,
    required super.likes,
    required super.blurHash,
    super.isThatImage = true,
  });

  static Story fromSnap({required DocumentSnapshot<Map<String, dynamic>> docSnap}) {
    return Story(
      caption: docSnap.data()?["caption"] ?? "",
      datePublished: docSnap.data()?["datePublished"] ?? "",
      publisherId: docSnap.data()?["publisherId"] ?? "",
      likes: docSnap.data()?["likes"] ?? [],
      comments: docSnap.data()?["comments"] ?? [],
      blurHash: docSnap.data()?["blurHash"] ?? "",
      storyUid: docSnap.data()?["storyUid"] ?? "",
      storyUrl: docSnap.data()?["storyUrl"] ?? "",
      isThatImage: docSnap.data()?["isThatImage"] ?? true,
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
        "blurHash": blurHash,
      };
}
