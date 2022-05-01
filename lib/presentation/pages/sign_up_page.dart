import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/core/utility/constant.dart';
import 'package:instegram/domain/entities/unregistered_user.dart';
import 'package:instegram/presentation/screens/main_screen.dart';
import 'package:instegram/presentation/widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                IconsAssets.instagramLogo,
                color: ColorManager.black,
                height: 50,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                  hint: StringsManager.phoneOrEmailOrUserName.tr(),
                  controller: emailController),
              const SizedBox(height: 15),
              CustomTextField(
                  hint: StringsManager.password.tr(),
                  controller: passwordController),
              const SizedBox(height: 15),
              CustomTextField(
                  hint: StringsManager.confirmPassword.tr(),
                  controller: confirmPasswordController),
              const SizedBox(height: 15),
              customTextButton(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    StringsManager.haveAccount.tr(),
                    style:const TextStyle(fontSize: 13, color: ColorManager.grey),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child:  Text(
                        StringsManager.logIn.tr(),
                        style:const TextStyle(
                            fontSize: 13,
                            color: ColorManager.black,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              const SizedBox(height: 8),
              const OrText(),
              TextButton(
                  onPressed: () {},
                  child:  Text(
                    StringsManager.loginWithFacebook.tr(),
                    style:const TextStyle(color: ColorManager.blue),
                  ))
            ],
          ),
        )),
      ),
    );
  }

  Widget customTextButton() {
    return Builder(builder: (context) {
      FirestoreAddNewUserCubit userCubit =
          FirestoreAddNewUserCubit.get(context);
      return BlocBuilder<FirebaseAuthCubit, FirebaseAuthCubitState>(
        builder: (context, authState) {
          FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);
          if (authState is CubitAuthConfirmed) {
            addNewUser(authState, userCubit);
            moveToMain(authState);
          } else if (authState is CubitAuthFailed) {
            authFailed(authState);
          }
          return CustomElevatedButton(
            isItDone: authState is! CubitAuthConfirming,
            nameOfButton: StringsManager.signUp.tr(),
            onPressed: () async {
              await authCubit.signUp(UnRegisteredUser(
                  email: emailController.text,
                  password: passwordController.text,
                  confirmPassword: confirmPasswordController.text));
            },
          );
        },
      );
    });
  }

  Future<void> onPressed(FirebaseAuthCubit authCubit) async {
    await authCubit.signUp(UnRegisteredUser(
        email: emailController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text));
  }

  moveToMain(CubitAuthConfirmed authState) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      sharePrefs=await SharedPreferences.getInstance();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(authState.user.uid)),
        (Route<dynamic> route) => false,
      );
    });
  }

  authFailed(CubitAuthFailed authState) {
    String error;
    try {
      error = authState.error.split(RegExp(r']'))[1];
    } catch (e) {
      error = authState.error;
    }
    ToastShow.toast(error);
  }

  addNewUser(CubitAuthConfirmed authState, FirestoreAddNewUserCubit userCubit) {
    // TODO ----> we need to get more details from user in the first to change this view

    String name = authState.user.email!.split('@')[0];
    List<dynamic> charactersOfName=[];
    String nameOfLower=name.toLowerCase();

    for(int i=0;i<nameOfLower.length;i++){
      charactersOfName=charactersOfName+[nameOfLower.substring(0,i+1)];
    }
    String userName = "${name}4263";
    UserPersonalInfo newUserInfo = UserPersonalInfo(
      name: name,
      charactersOfName:charactersOfName,
      email: authState.user.email!,
      userName: userName,
      bio: "",
      profileImageUrl: "",
      userId: authState.user.uid,
      followerPeople: const [],
      followedPeople: const [],
      posts: const [],
      stories: const [],
    );
    userCubit.addNewUser(newUserInfo);
  }
}
