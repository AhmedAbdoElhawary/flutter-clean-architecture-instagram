import 'package:instegram/domain/entities/new_user_info.dart';

class UserPersonalInfo extends NewUserInfo {
  List<dynamic> followedPeople=[];
  List<dynamic> followerPeople=[];
  List<dynamic> posts=[];

  UserPersonalInfo(
      { List<dynamic>? followedPeople,
        List<dynamic>? followerPeople,
        List<dynamic>? posts,
      String name = "",
      String userName = "",
      String bio = "",
      String email = "",
      String profileImageUrl = "",
      String userId = ""})
      : super(
            name: name,
            userName: userName,
            bio: bio,
            email: email,
            profileImageUrl: profileImageUrl,
            userId: userId);
  Map<String, dynamic> toMap() {
    return {
      'followedPeople': followedPeople,
      'followerPeople': followerPeople,
      'posts': posts,
      'name': name,
      'userName': userName,
      'bio': bio,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'userId': userId,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  // id: $id, name: $name, age: $age
  @override
  String toString() {
    return 'UserPersonalInfo{followedPeople: $followedPeople, followerPeople: $followerPeople, posts: $posts, name: $name, userName: $userName, bio: $bio, email: $email, profileImageUrl: $profileImageUrl, userId: $userId}';
  }
}
