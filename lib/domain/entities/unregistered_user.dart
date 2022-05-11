import 'package:instagram/domain/entities/registered_user.dart';

class UnRegisteredUser extends RegisteredUser {
  String confirmPassword;
  UnRegisteredUser(
      {String email = "", String password = "", this.confirmPassword = ""})
      : super(email: email, password: password);
}
