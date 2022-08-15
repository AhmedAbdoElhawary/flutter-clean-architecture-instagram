import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:instagram/core/app_prefs.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/domain/entities/unregistered_user.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/screens/responsive_layout.dart';
import 'package:instagram/presentation/screens/web_screen_layout.dart';
import 'package:instagram/presentation/widgets/belong_to/register_w/popup_calling.dart';
import 'package:instagram/presentation/widgets/belong_to/register_w/register_widgets.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_elevated_button.dart';
import '../../../data/models/user_personal_info.dart';
import '../../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../../cubit/firestoreUserInfoCubit/add_new_user_cubit.dart';
import '../../../core/functions/toast_show.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final isToastShowed = ValueNotifier(false);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AppPreferences _appPreferences = injector<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }

  @override
  dispose() {
    super.dispose();
    isToastShowed.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterWidgets(
      confirmPasswordController: confirmPasswordController,
      customTextButton: customTextButton(),
      emailController: emailController,
      passwordController: passwordController,
      isThatLogIn: false,
    );
  }

  Widget customTextButton() {
    return Builder(builder: (context) {
      FirestoreAddNewUserCubit userCubit =
          FirestoreAddNewUserCubit.get(context);
      return ValueListenableBuilder(
        valueListenable: isToastShowed,
        builder: (context, bool isToastShowedValue, child) =>
            BlocBuilder<FirebaseAuthCubit, FirebaseAuthCubitState>(
          builder: (context, authState) {
            FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);
            if (authState is CubitAuthConfirmed) {
              addNewUser(authState, userCubit);
              moveToMain(authState);
            } else if (authState is CubitAuthFailed && !isToastShowedValue) {
              authFailed(authState);
            }
            return CustomElevatedButton(
              isItDone: authState is! CubitAuthConfirming,
              nameOfButton: StringsManager.signUp.tr(),
              onPressed: () async {
                isToastShowed.value = false;
                await authCubit.signUp(UnRegisteredUser(
                    email: emailController.text,
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text));
              },
            );
          },
        ),
      );
    });
  }

  moveToMain(CubitAuthConfirmed authState) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      myPersonalId = authState.user.uid;
      Get.offAll(
        ResponsiveLayout(
          mobileScreenLayout: PopupCalling(myPersonalId),
          webScreenLayout: const WebScreenLayout(),
        ),
      );
    });
  }

  authFailed(CubitAuthFailed authState) {
    isToastShowed.value = true;
    String error;
    try {
      error = authState.error.split(RegExp(r']'))[1];
    } catch (e) {
      error = authState.error;
    }
    ToastShow.toast(error);
  }

  addNewUser(CubitAuthConfirmed authState, FirestoreAddNewUserCubit userCubit) {
    // ignore: todo
    // TODO ----> we need to get more details from user in the first to change this view

    String name = authState.user.email!.split('@')[0];
    List<dynamic> charactersOfName = [];
    String nameOfLower = name.toLowerCase();

    for (int i = 0; i < nameOfLower.length; i++) {
      charactersOfName = charactersOfName + [nameOfLower.substring(0, i + 1)];
    }
    String userName = "${name}4263";
    UserPersonalInfo newUserInfo = UserPersonalInfo(
      name: name,
      charactersOfName: charactersOfName,
      email: authState.user.email!,
      userName: userName,
      bio: "",
      profileImageUrl: "",
      userId: authState.user.uid,
      followerPeople: const [],
      followedPeople: const [],
      posts: const [],
      stories: const [],
      devicesTokens: const [],
    );
    userCubit.addNewUser(newUserInfo);
  }
}
