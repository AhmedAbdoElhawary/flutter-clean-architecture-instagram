import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/parent_classes/post/parent_post.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

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
  }) : super(
          datePublished: datePublished,
          likes: likes,
          comments: comments,
          publisherId: publisherId,
          caption: caption,
          blurHash: blurHash,
          publisherInfo: publisherInfo,
        );

  static Post fromQuery(
      {DocumentSnapshot<Map<String, dynamic>>? doc,
      QueryDocumentSnapshot<Map<String, dynamic>>? query}) {
    dynamic snap = doc ?? query;
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
        "coverOfVideoUrl": coverOfVideoUrl,
      };
}
