import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram/core/constant.dart';
import 'package:instegram/domain/entities/registered_user.dart';
import 'package:instegram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/pages/sign_up_page.dart';
import 'package:instegram/presentation/widgets/custom_text_field.dart';
import 'package:instegram/presentation/widgets/or_text.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  bool isHeMovedToHome = false;

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
              CustomTextField(hint: "Password", controller: passwordController),
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
                                builder: (context) => const SignUpPage()));
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
    bool isUserIdReady = true;
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
                        String userId = authCubit.user!.uid;
                        getUserCubit.getUserInfo(userId,true);
                        if (getUserState is CubitMyPersonalInfoLoaded) {
                          WidgetsBinding.instance!
                              .addPostFrameCallback((_) async {
                            setState(() {
                              isUserIdReady = true;
                            });
                            if (!isHeMovedToHome) {
                              myPersonalId=userId;
                              print('$myPersonalId ===================================');
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/main', (route) => false,
                                  arguments: userId);
                            }
                            isHeMovedToHome = true;
                          });
                        } else if (getUserState is CubitGetUserInfoFailed) {
                          WidgetsBinding.instance!
                              .addPostFrameCallback((_) async {
                            setState(() {
                              isUserIdReady = true;
                            });
                          });

                          ToastShow.toastStateError(getUserState);
                        }
                      } else if (authState is CubitAuthFailed) {
                        WidgetsBinding.instance!
                            .addPostFrameCallback((_) async {
                          setState(() {
                            isUserIdReady = true;
                          });
                        });

                        ToastShow.toastStateError(authState);
                      }

                      return TextButton(
                          onPressed: () async {
                            isUserIdReady = false;
                            await authCubit.logIn(RegisteredUser(
                                email: emailController.text,
                                password: passwordController.text));
                          },
                          child: !isUserIdReady
                              ? const ClipOval(
                                  child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
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
