import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

class FollowersAndFollowingsInfo {
  List<UserPersonalInfo> followingsInfo;
  List<UserPersonalInfo> followersInfo;

  FollowersAndFollowingsInfo(
      {required this.followingsInfo, required this.followersInfo});
}
