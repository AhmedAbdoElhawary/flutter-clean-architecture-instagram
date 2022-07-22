import 'package:instagram/data/models/user_personal_info.dart';

class FollowersAndFollowingsInfo {
  List<UserPersonalInfo> followingsInfo;
  List<UserPersonalInfo> followersInfo;

  FollowersAndFollowingsInfo({
    required this.followingsInfo,
    required this.followersInfo,
  });
}
