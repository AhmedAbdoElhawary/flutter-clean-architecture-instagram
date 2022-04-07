import 'package:flutter/material.dart';
import 'package:instegram/core/constant.dart';
import 'package:instegram/presentation/pages/personal_profile_page.dart';
import 'package:instegram/presentation/pages/user_profile_page.dart';

class WhichProfilePage extends StatelessWidget {
  final String userId;
  const WhichProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userId == myPersonalId
        ? PersonalProfilePage(userId)
        : UserProfilePage(userId);
  }
}
