import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram/presentation/pages/sign_up_page.dart';
import '../../domain/entities/registered_user.dart';
import '../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../cubit/firestoreUserInfoCubit/firestore_user_info_cubit.dart';
import '../screens/main_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/or_text.dart';
import '../widgets/toast_show.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/ic_instagram.svg",
                color: Colors.black,
                height: 50,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                  hint: "Phone number, email or username",
                  controller: emailController),
              const SizedBox(height: 15),
              CustomTextField(
                  hint: "Password", controller: passwordController),
              const SizedBox(height: 15),
              customTextButton(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              const SizedBox(height: 8),
              const OrText(),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Login with Facebook",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          ),
        )),
      ),
    );
  }

  Widget customTextButton() {
    return BlocConsumer<FirebaseAuthCubit, FirebaseAuthCubitState>(
      listener: (context, state) {},
      builder: (context, authState) {
        FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);

        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: 45,
                  child: BlocConsumer<FirestoreUserInfoCubit,
                      FirestoreGetUserInfoState>(
                    listener: (context, state) {},
                    builder: (context, getUserState) {
                      FirestoreUserInfoCubit getUserCubit =
                          FirestoreUserInfoCubit.get(context);
                      if (authState is CubitAuthConfirmed) {
                        getUserCubit.getUserInfo(authCubit.user!.uid);
                        if (getUserState is CubitUserLoaded) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) async {
                            // UserPersonalInfo prefsUserInfo=getUserState.userPersonalInfo;
                            // Map<String, dynamic> userInfo =
                            // {'followedPeople':prefsUserInfo.followedPeople,
                            //   'followerPeople':prefsUserInfo.followerPeople,
                            //   'posts':prefsUserInfo.posts,
                            //   'name':prefsUserInfo.name,
                            //   'userName':prefsUserInfo.userName,
                            //   'bio':prefsUserInfo.bio,
                            //   'email':prefsUserInfo.email,
                            //   'profileImageUrl':prefsUserInfo.profileImageUrl,
                            //   'userId':prefsUserInfo.userId};
                            // final prefs = await SharedPreferences.getInstance();
                            // await prefs.setString('userInfo', jsonEncode(userInfo));
                            // await prefs.setBool('registered', true);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen(
                                      getUserState.userPersonalInfo)),
                              (Route<dynamic> route) => false,
                            );
                          });
                        } else if (getUserState is CubitGetUserInfoFailed) {
                          String error;
                          try {
                            error = getUserState.error.split(RegExp(r']'))[1];
                          } catch (e) {
                            error = getUserState.error;
                          }
                          ToastShow.toast(error);
                        }
                      } else if (authState is CubitAuthFailed) {
                        String error;
                        try {
                          error = authState.error.split(RegExp(r']'))[1];
                        } catch (e) {
                          error = authState.error;
                        }
                        ToastShow.toast(error);
                      }

                      return TextButton(
                          onPressed: () async {
                            await authCubit.logIn(RegisteredUser(
                                email: emailController.text,
                                password: passwordController.text));
                          },
                          child: getUserState is CubitUserLoading ||
                                  authState is CubitAuthConfirming
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Log in",
                                  style: TextStyle(color: Colors.white),
                                ),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.blue));
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
