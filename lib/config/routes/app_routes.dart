import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram/presentation/pages/edit_profile_page.dart';
import 'package:instegram/presentation/pages/home_page.dart';
import 'package:instegram/presentation/pages/login_page.dart';
import 'package:instegram/presentation/pages/new_post_page.dart';
import 'package:instegram/presentation/pages/profile_page.dart';
import 'package:instegram/presentation/screens/main_screen.dart';
import '../../data/models/user_personal_info.dart';

class AppRoutes {
  static Route? onGenerateRoutes(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      case '/login':
        return _materialRoute(LoginPage());
      case '/main':
        return _materialRoute(MainScreen(arg as String));
      case '/home':
        return _materialRoute(const HomeScreen());
      case '/profile':
        return _materialRoute(ProfilePage(arg as String));
      case '/edit_profile':
        return _materialRoute(EditProfilePage(arg as UserPersonalInfo));
      case '/create_post':
        return _materialRoute(CreatePostPage(arg as XFile));
      default:
        return null;
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
