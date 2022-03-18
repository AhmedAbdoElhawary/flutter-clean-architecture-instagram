import 'package:instegram/domain/entities/followed_user_info.dart';
import 'package:instegram/domain/entities/followers_user_info.dart';
import 'package:instegram/domain/entities/new_user_info.dart';

class UserPersonalInfo extends NewUserInfo {
  List<dynamic> followedPeople;
  List<dynamic> followerPeople;
  List<dynamic> posts;

  UserPersonalInfo(
      {required this.followedPeople,
      required this.followerPeople,
      required this.posts,
      required String name,
      required String userName,
      required String bio,
      required String email,
      required String profileImageUrl,
      required String userId})
      : super(
            name: name,
            userName: userName,
            bio: bio,
            email: email,
            profileImageUrl: profileImageUrl,
            userId: userId);
}
