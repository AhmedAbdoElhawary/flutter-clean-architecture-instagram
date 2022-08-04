import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/parent_post.dart';
import 'package:instagram/data/models/user_personal_info.dart';

class Post extends ParentPost {
  String postUrl;
  List<dynamic> imagesUrls;
  String postUid;
  double aspectRatio;
  String coverOfVideoUrl;
  Post({
    required String datePublished,
    required String publisherId,
    UserPersonalInfo? publisherInfo,
    this.postUid = "",
    this.coverOfVideoUrl = "",
    this.postUrl = "",
    required this.imagesUrls,
    required this.aspectRatio,
    String caption = "",
    required List<dynamic> comments,
    required String blurHash,
    required List<dynamic> likes,
    bool isThatImage = true,
  }) : super(
          datePublished: datePublished,
          likes: likes,
          comments: comments,
          publisherId: publisherId,
          isThatImage: isThatImage,
          caption: caption,
          blurHash: blurHash,
          publisherInfo: publisherInfo,
        );

  static Post fromQuery(
      {DocumentSnapshot<Map<String, dynamic>>? query,
      QueryDocumentSnapshot<Map<String, dynamic>>? doc}) {
    dynamic snap = query ?? doc;
    return Post(
      caption: snap.data()?["caption"] ?? "",
      datePublished: snap.data()?["datePublished"] ?? "",
      publisherId: snap.data()?["publisherId"] ?? "",
      likes: snap.data()?["likes"] ?? [],
      comments: snap.data()?["comments"] ?? [],
      blurHash: snap.data()?["blurHash"] ?? "",
      coverOfVideoUrl: snap.data()?["coverOfVideoUrl"] ?? "",
      imagesUrls: snap.data()?["imagesUrls"] ?? [],
      postUid: snap.data()?["postUid"] ?? "",
      aspectRatio: snap.data()?["aspectRatio"] ?? 0.0,
      postUrl: snap.data()?["postUrl"] ?? "",
      isThatImage: snap.data()?["isThatImage"] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'caption': caption,
        "datePublished": datePublished,
        "publisherId": publisherId,
        'comments': comments,
        'aspectRatio': aspectRatio,
        'imagesUrls': imagesUrls,
        'blurHash': blurHash,
        'likes': likes,
        'postUid': postUid,
        "postUrl": postUrl,
        "isThatImage": isThatImage,
        "coverOfVideoUrl": coverOfVideoUrl,
      };
}
