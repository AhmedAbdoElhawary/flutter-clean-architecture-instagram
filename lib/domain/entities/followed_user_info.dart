class FollowedUserInfo {
  String followedId;
  String name;
  String profileImageUrl;
  String userName;
  bool isFollowed;

  FollowedUserInfo(
      {this.followedId = "",
      this.name = "",
      this.profileImageUrl = "",
      this.userName = "",
      this.isFollowed = false});
}
