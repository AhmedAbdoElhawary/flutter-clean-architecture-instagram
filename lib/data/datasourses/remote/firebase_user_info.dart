import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instegram/data/models/user_personal_info.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:path/path.dart';

class FirestoreUsers {
  static final _firestoreUserCollection =
      FirebaseFirestore.instance.collection('users');

  static addNewUser(UserPersonalInfo newUserInfo) async {
    await _firestoreUserCollection.doc(newUserInfo.userId).set({
      'bio': newUserInfo.bio,
      "email": newUserInfo.email,
      "followers": newUserInfo.followerPeople,
      "following": newUserInfo.followedPeople,
      'name': newUserInfo.name,
      "posts": newUserInfo.posts,
      "profileImageUrl": newUserInfo.profileImageUrl,
      "userName": newUserInfo.userName,
      "uid": newUserInfo.userId,
    });
  }

  static Future<UserPersonalInfo> getUserInfo(String userId) async {
    DocumentSnapshot<Object?> snap =
        await _firestoreUserCollection.doc(userId).get();
    if (snap.exists) {
      return UserPersonalInfo(
          name: snap.get("name"),
          userId: snap.get("uid"),
          profileImageUrl: snap.get("profileImageUrl"),
          email: snap.get("email"),
          bio: snap.get("bio"),
          userName: snap.get("userName"),
          posts: snap.get("posts"),
          followedPeople: snap.get("following"),
          followerPeople: snap.get("followers"));
    }
    return Future.error("the user not exist !");
  }

  static updateUserInfo(UserPersonalInfo userInfo) async {
    await _firestoreUserCollection.doc(userInfo.userId).update({
      'bio': userInfo.bio,
      "email": userInfo.email,
      "followers": userInfo.followerPeople,
      "following": userInfo.followedPeople,
      'name': userInfo.name,
      "posts": userInfo.posts,
      "profileImageUrl": userInfo.profileImageUrl,
      "userName": userInfo.userName,
      "uid": userInfo.userId,
    });
  }
  static Future<String> uploadImage(File photo) async {
    // Reference reference = FirebaseStorage.instance.ref().child("SupportChatImages").child(fileName);
    //
    // UploadTask uploadTask =  reference.putFile(imageFile);
    //
    // uploadTask.whenComplete(() async{
    //
    //   try{
    //     imageUrl = await reference.getDownloadURL();
    //   }catch(onError){
    //     print("Error");
    //   }
    //
    //   print(imageUrl);
    //
    // });
    final fileName = basename(photo.path);
    final destination = 'files/personalImage/$fileName';
    final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
    UploadTask uploadTask = ref.putFile(photo);
    var imageUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return imageUrl.toString();
  }

  static updateProfileImage({required String imageUrl, required String userId}) async {
    await _firestoreUserCollection.doc(userId).update({
      "profileImageUrl": imageUrl,
    });
  }

  // Future uploadImageToFirebase(BuildContext context, String _imageFile) async {
  //   String fileName = Path.basename(_imageFile);
  //   Reference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('uploads/$fileName');
  //   UploadTask uploadTask = firebaseStorageRef.putString(_imageFile);
  //   TaskSnapshot taskSnapshot = uploadTask.snapshot;
  //   taskSnapshot.ref.getDownloadURL().then(
  //         (value) => print("Done: $value"),
  //       );
  // }



//
//   updateImageUrl({required String studentDocId, required String imageUrl}) {
//     _firestoreCollectionStudents
//         .doc(studentDocId)
//         .update({"imageUrl": imageUrl})
//         .then((value) {})
//         .catchError((error) =>
//             ToastShow().whiteToast("Failed to update user image: $error"));
//   }
//
//   addMembership({required String seasonDocId, required String studentDocId}) {
//     _firestoreCollectionStudents
//         .doc(studentDocId)
//         .update({
//           'memberships': FieldValue.arrayUnion([seasonDocId]),
//         })
//         .then((value) {})
//         .catchError((error) =>
//             ToastShow().redToast("Failed to add membership in user -> $error"));
//   }
//
//   deleteMembership(
//       {required String seasonDocId, required String studentDocId}) {
//     _firestoreCollectionStudents
//         .doc(studentDocId)
//         .update({
//           'memberships': FieldValue.arrayRemove([seasonDocId]),
//         })
//         .then((value) {})
//         .catchError((error) =>
//             ToastShow().redToast("Failed to delete membership -> $error"));
//   }
//
//   deleteStudent(String studentDocId) =>
//       _firestoreCollectionStudents.doc(studentDocId).delete();

}
