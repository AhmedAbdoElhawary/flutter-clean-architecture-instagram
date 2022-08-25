import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/config/routes/app_routes.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/domain/entities/registered_user.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/searchAboutUser/search_about_user_bloc.dart';
import 'package:instagram/presentation/screens/responsive_layout.dart';
import 'package:instagram/presentation/screens/web_screen_layout.dart';
import 'package:instagram/presentation/widgets/belong_to/register_w/popup_calling.dart';
import 'package:instagram/presentation/widgets/belong_to/register_w/register_widgets.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../../cubit/firestoreUserInfoCubit/add_new_user_cubit.dart';
import '../../../core/functions/toast_show.dart';

class TextsControllers {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController fullNameController;

  TextsControllers({
    required this.emailController,
    required this.passwordController,
    required this.fullNameController,
  });
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final bool validateControllers = false;
  ValueNotifier<bool> validateEmail = ValueNotifier(false);
  ValueNotifier<bool> validatePassword = ValueNotifier(false);
  ValueNotifier<bool> rememberPassword = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return RegisterWidgets(
      fullNameController: fullNameController,
      customTextButton: customTextButton(),
      emailController: emailController,
      passwordController: passwordController,
      isThatLogIn: false,
      validateEmail: validateEmail,
      validatePassword: validatePassword,
      rememberPassword: rememberPassword,
    );
  }

  Widget customTextButton() {
    return ValueListenableBuilder(
      valueListenable: rememberPassword,
      builder: (context, bool rememberPasswordValue, child) =>
          ValueListenableBuilder(
        valueListenable: validateEmail,
        builder: (context, bool validateEmailValue, child) =>
            ValueListenableBuilder(
          valueListenable: validatePassword,
          builder: (context, bool validatePasswordValue, child) {
            bool validate = validatePasswordValue &&
                validateEmailValue &&
                rememberPasswordValue;
            return CustomElevatedButton(
              isItDone: true,
              isThatSignIn: true,
              nameOfButton: StringsManager.next.tr,
              blueColor: validate ? true : false,
              onPressed: () async {
                if (validate) {
                  TextsControllers textsControllers = TextsControllers(
                    emailController: emailController,
                    passwordController: passwordController,
                    fullNameController: fullNameController,
                  );
                  pushToPage(context, page: UserNamePage(textsControllers));
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class UserNamePage extends StatefulWidget {
  final TextsControllers textsControllers;
  const UserNamePage(this.textsControllers, {Key? key}) : super(key: key);

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final userNameController = TextEditingController();
  final isToastShowed = ValueNotifier(false);
  bool validateEdits = false;
  bool isFieldEmpty = true;
  bool isItMoved = false;

  @override
  dispose() {
    super.dispose();
    isToastShowed.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                StringsManager.createUserName.tr,
                style: getMediumStyle(
                    color: Theme.of(context).focusColor, fontSize: 15),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  StringsManager.addUserName.tr,
                  style: getNormalStyle(color: ColorManager.grey, fontSize: 13),
                ),
              ),
              Text(
                StringsManager.youCanChangeUserNameLater.tr,
                style: getNormalStyle(color: ColorManager.grey, fontSize: 13),
              ),
              const SizedBox(height: 30),
              userNameTextField(context),
              customTextButton(),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<SearchAboutUserBloc, SearchAboutUserState> userNameTextField(
      BuildContext context) {
    return BlocBuilder<SearchAboutUserBloc, SearchAboutUserState>(
      bloc: BlocProvider.of<SearchAboutUserBloc>(context)
        ..add(FindSpecificUser(userNameController.text,
            searchForSingleLetter: true)),
      buildWhen: (previous, current) =>
          previous != current && (current is SearchAboutUserBlocLoaded),
      builder: (context, state) {
        List<UserPersonalInfo> usersWithSameUserName = [];
        if (state is SearchAboutUserBlocLoaded) {
          usersWithSameUserName = state.users;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
              validateEdits = usersWithSameUserName.isEmpty;
              if (userNameController.text.isEmpty) {
                validateEdits = false;
                isFieldEmpty = true;
              } else {
                isFieldEmpty = false;
              }
            }));

        return customTextField(validateEdits);
      },
    );
  }

  Padding customTextField(bool uniqueUserName) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
      child: SizedBox(
        height: isThatMobile ? null : 37,
        width: double.infinity,
        child: TextFormField(
          controller: userNameController,
          cursorColor: ColorManager.teal,
          style:
              getNormalStyle(color: Theme.of(context).focusColor, fontSize: 15),
          decoration: InputDecoration(
            hintText: StringsManager.username.tr,
            hintStyle: isThatMobile
                ? getNormalStyle(color: Theme.of(context).indicatorColor)
                : getNormalStyle(color: ColorManager.black54, fontSize: 12),
            fillColor: const Color.fromARGB(48, 232, 232, 232),
            filled: true,
            focusedBorder: outlineInputBorder(),
            suffixIcon: isFieldEmpty
                ? null
                : (uniqueUserName ? rightIcon() : wrongIcon()),
            enabledBorder: outlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 10, vertical: isThatMobile ? 15 : 5),
            errorText: isFieldEmpty || uniqueUserName
                ? null
                : StringsManager.thisUserNameExist.tr,
            errorStyle: getNormalStyle(color: ColorManager.red),
          ),
        ),
      ),
    );
  }

  Icon rightIcon() {
    return const Icon(Icons.check_rounded, color: ColorManager.green, size: 27);
  }

  Widget wrongIcon() {
    return const Icon(
      Icons.close_rounded,
      color: ColorManager.red,
      size: 27,
    );
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(isThatMobile ? 5.0 : 1.0),
      borderSide: BorderSide(
          color: ColorManager.lightGrey, width: isThatMobile ? 1.0 : 0.3),
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
              nameOfButton: StringsManager.signUp.tr,
              blueColor: validateEdits,
              onPressed: () async {
                if (validateEdits) {
                  isToastShowed.value = false;
                  await authCubit.signUp(RegisteredUser(
                    email: widget.textsControllers.emailController.text,
                    password: widget.textsControllers.passwordController.text,
                  ));
                }
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
      final SharedPreferences sharePrefs = injector<SharedPreferences>();
      await sharePrefs.setString("myPersonalId", myPersonalId);
      if (!isItMoved) {
        isItMoved = true;
        Get.offAll(
          ResponsiveLayout(
            mobileScreenLayout: PopupCalling(myPersonalId),
            webScreenLayout: const WebScreenLayout(),
          ),
        );
      }
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
    String fullName = widget.textsControllers.fullNameController.text;
    List<dynamic> charactersOfName = [];
    String nameOfLower = fullName.toLowerCase();

    for (int i = 0; i < nameOfLower.length; i++) {
      charactersOfName = charactersOfName + [nameOfLower.substring(0, i + 1)];
    }
    String userName = userNameController.text;
    UserPersonalInfo newUserInfo = UserPersonalInfo(
      name: fullName,
      charactersOfName: charactersOfName,
      email: authState.user.email!,
      userName: userName,
      bio: "",
      profileImageUrl: "",
      userId: authState.user.uid,
      followerPeople: const [],
      followedPeople: const [],
      posts: const [],
      chatsOfGroups: const [],
      stories: const [],
      lastThreePostUrls: const [],
    );
    userCubit.addNewUser(newUserInfo);
  }
}
