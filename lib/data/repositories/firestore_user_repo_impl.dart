import 'package:instegram/domain/entities/user_personal_info.dart';

import '../../domain/entities/new_user_info.dart';
import '../../domain/repositories/firestore_user_repo.dart';
import '../datasourses/remote/firebase_user_info.dart';

class FirebaseUserRepoImpl implements FirestoreUserRepository {
  @override
  Future<void> addNewUser(UserPersonalInfo newUserInfo) async {
    try {
      return await FirestoreUsers.addNewUser(newUserInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> getPersonalInfo(String userId) async {
    try {
      return await FirestoreUsers.getUserInfo(userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
