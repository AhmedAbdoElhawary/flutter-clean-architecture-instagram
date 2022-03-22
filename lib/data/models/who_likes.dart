import 'package:cloud_firestore/cloud_firestore.dart';

class WhoLikes {
  String name;
  String profileImageUrl;
  String userName;
  String whoLikesId;

  WhoLikes({
    required this.name,
    required this.profileImageUrl,
    required this.userName,
    required this.whoLikesId,
  });
  static WhoLikes fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return WhoLikes(
      name: snapshot["name"],
      profileImageUrl: snapshot["profileImageUrl"],
      userName: snapshot["userName"],
      whoLikesId: snapshot["whoLikesId"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profileImageUrl': profileImageUrl,
      'userName': userName,
      'whoLikesId': whoLikesId,
    };
  }
}
