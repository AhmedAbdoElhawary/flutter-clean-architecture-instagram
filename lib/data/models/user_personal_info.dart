import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instegram/data/models/story.dart';

class UserPersonalInfo {
  String bio;
  String email;
  String name;
  String profileImageUrl;
  String userName;
  String userId;
  List<dynamic> followedPeople;
  List<dynamic> followerPeople;
  List<dynamic> posts;
  List<dynamic> stories;
  List<Story>? storiesInfo;

  UserPersonalInfo(
      {required this.followedPeople,
      required this.followerPeople,
      required this.posts,
      required this.stories,
      this.storiesInfo,
      this.name = "",
      this.bio = "",
      this.email = "",
      this.profileImageUrl = "",
      this.userName = "",
      this.userId = ""});

  static UserPersonalInfo fromDocSnap(
      {DocumentSnapshot<Map<String, dynamic>>? docSnap,
      Map<String, dynamic>? mapSnap}) {
    dynamic snap = docSnap ?? mapSnap;
    return UserPersonalInfo(
      name: snap["name"],
      userId: snap["uid"],
      profileImageUrl: snap["profileImageUrl"],
      email: snap["email"],
      bio: snap["bio"],
      userName: snap["userName"],
      posts: snap['posts'],
      stories: snap['stories'],
      followedPeople: snap['following'],
      followerPeople: snap['followers'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'following': followedPeople,
      'followers': followerPeople,
      'posts': posts,
      'stories': stories,
      'name': name,
      'userName': userName,
      'bio': bio,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'uid': userId,
    };
  }
}
