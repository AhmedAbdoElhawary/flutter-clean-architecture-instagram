import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/parent_classes/post/parent_post.dart';

class Post extends ParentPost {
  String postUrl;
  List<dynamic> imagesUrls;
  String postUid;
  double aspectRatio;
  String coverOfVideoUrl;

  /// is this post contains images and videos.
  /// It's not the best way, we can combine [isThatImage] and [isThatMix] in enum for example,
  /// But, i made this way because i have a lot of data in the backend without [isThatMix]
  bool isThatMix = false;
  Post({
    required super.datePublished,
    required super.publisherId,
    super.publisherInfo,
    this.postUid = "",
    this.coverOfVideoUrl = "",
    this.isThatMix = false,
    this.postUrl = "",
    required this.imagesUrls,
    required this.aspectRatio,
    super.caption,
    required super.comments,
    required super.blurHash,
    required super.likes,
    super.isThatImage = true,
  });

  static Post fromQuery(
      {DocumentSnapshot<Map<String, dynamic>>? doc,
      QueryDocumentSnapshot<Map<String, dynamic>>? query}) {
    dynamic snap = doc ?? query;
    dynamic aspect = snap.data()?["aspectRatio"];
    if (aspect is int) aspect = aspect.toDouble();

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
      aspectRatio: aspect ?? 0.0,
      postUrl: snap.data()?["postUrl"] ?? "",
      isThatImage: snap.data()?["isThatImage"] ?? true,
      isThatMix: snap.data()?["isThatMix"] ?? false,
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
        "isThatImage": isThatImage,
        "isThatMix": isThatMix,
      };
}
