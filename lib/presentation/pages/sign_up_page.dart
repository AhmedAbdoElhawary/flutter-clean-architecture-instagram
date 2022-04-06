import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram/domain/entities/unregistered_user.dart';
import '../../data/models/user_personal_info.dart';
import '../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../cubit/firestoreUserInfoCubit/add_new_user_cubit.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/or_text.dart';
import '../widgets/toast_show.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confirmPasswordController =
      TextEditingController(text: "");

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
              CustomTextField(
                  hint: "Confirm the password",
                  controller: confirmPasswordController),
              const SizedBox(height: 15),
              customTextButton(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Log in",
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
                  child: BlocConsumer<FirestoreAddNewUserCubit,
                      FirestoreAddNewUserState>(
                    listener: (context, state) {},
                    builder: (context, userState) {
                      FirestoreAddNewUserCubit userCubit =
                          FirestoreAddNewUserCubit.get(context);
                      if (authState is CubitAuthConfirmed) {
                        // TODO ----> we need to get more details from user in the first to change this view

                        String name = authState.user.email!.split('@')[0];
                        String userName = "${name}4263";
                        UserPersonalInfo newUserInfo = UserPersonalInfo(
                            name: name,
                            email: authState.user.email!,
                            userName: userName,
                            bio: "",
                            profileImageUrl: "",
                            userId: authState.user.uid,
                            followerPeople: [],
                            followedPeople: [],
                            posts: []);
                        userCubit.addNewUser(newUserInfo);
                        if (userState is CubitUserAdded) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) async {

                            // final prefs = await SharedPreferences.getInstance();
                            // await prefs.setString('userInfo', jsonEncode(newUserInfo));
                            // await prefs.setBool('registered', true);

                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           MainScreen(newUserInfo)),
                            //   (Route<dynamic> route) => false,
                            // );
                          });
                        } else if (userState is CubitAddNewUserFailed) {
                          String error;
                          try {
                            error = userState.error.split(RegExp(r']'))[1];
                          } catch (e) {
                            error = userState.error;
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
                            await authCubit.signUp(UnRegisteredUser(
                                email: emailController.text,
                                password: passwordController.text,
                                confirmPassword:
                                    confirmPasswordController.text));
                          },
                          child: userState is CubitUserAdding ||
                                  authState is CubitAuthConfirming
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Sign Up",
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
