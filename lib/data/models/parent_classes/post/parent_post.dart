import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

abstract class ParentPost {
  String datePublished;
  String caption;
  String publisherId;
  List<dynamic> likes;
  List<dynamic> comments;
  UserPersonalInfo? publisherInfo;
  bool isThatImage;
  String blurHash;

  ParentPost({
    required this.datePublished,
    required this.publisherId,
    this.publisherInfo,
    this.caption = "",
    required this.comments,
    required this.blurHash,
    required this.likes,
    this.isThatImage = true,
  });
}
