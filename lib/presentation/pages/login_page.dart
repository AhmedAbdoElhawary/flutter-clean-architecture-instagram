import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram/core/app_prefs.dart';
import 'package:instegram/core/resources/assets_manager.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/core/utility/constant.dart';
import 'package:instegram/domain/entities/registered_user.dart';
import 'package:instegram/injector.dart';
import 'package:instegram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/pages/sign_up_page.dart';
import 'package:instegram/presentation/screens/main_screen.dart';
import 'package:instegram/presentation/widgets/custom_elevated_button.dart';
import 'package:instegram/presentation/widgets/custom_text_field.dart';
import 'package:instegram/presentation/widgets/or_text.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  bool isHeMovedToHome = false;
  bool isUserIdReady = true;
  final AppPreferences _appPreferences = injector<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
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
              SvgPicture.asset(IconsAssets.instagramLogo,
                  color: ColorManager.black, height: 50),
              const SizedBox(height: 30),
              CustomTextField(
                  hint: StringsManager.phoneOrEmailOrUserName.tr(),
                  controller: emailController),
              const SizedBox(height: 15),
              CustomTextField(
                  hint: StringsManager.password.tr(),
                  controller: passwordController),
              const SizedBox(height: 15),
              customTextButton(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringsManager.noAccount.tr(),
                    style:
                        const TextStyle(fontSize: 13, color: ColorManager.grey),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: Text(
                        StringsManager.signUp.tr(),
                        style: const TextStyle(
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
                  child: Text(
                    StringsManager.loginWithFacebook.tr(),
                    style: const TextStyle(color: ColorManager.blue),
                  ))
            ],
          ),
        )),
      ),
    );
  }

  Widget customTextButton() {
    return Builder(builder: (context) {
      FirestoreUserInfoCubit getUserCubit = FirestoreUserInfoCubit.get(context);

      return BlocBuilder<FirebaseAuthCubit, FirebaseAuthCubitState>(
        buildWhen: (previous, current) {
          if (previous != current && isUserIdReady) {
            return true;
          }
          if (previous != current && current is CubitAuthConfirmed) {
            return true;
          }
          return false;
        },
        builder: (context, authState) {
          FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            if (authState is CubitAuthConfirmed) {
              await getUserCubit.getUserInfo(authCubit.user!.uid, true);
              String userId = authCubit.user!.uid;
              setState(() {
                isUserIdReady = true;
              });
              if (!isHeMovedToHome) {
                myPersonalId = userId;

                sharePrefs = await SharedPreferences.getInstance();
                sharePrefs!.setString("myPersonalId", userId);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MainScreen(userId)));
              }
              isHeMovedToHome = true;
            } else if (authState is CubitAuthFailed) {
              setState(() {
                isUserIdReady = true;
              });
              ToastShow.toastStateError(authState);
            }
          });
          return CustomElevatedButton(
            isItDone: isUserIdReady,
            nameOfButton: StringsManager.logIn.tr(),
            onPressed: () async {
              isUserIdReady = false;
              await authCubit.logIn(RegisteredUser(
                  email: emailController.text,
                  password: passwordController.text));
            },
          );
        },
      );
    });
  }
}
