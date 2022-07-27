import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/app_prefs.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/domain/entities/registered_user.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/screens/mobile_screen_layout.dart';
import 'package:instagram/presentation/screens/responsive_layout.dart';
import 'package:instagram/presentation/screens/web_screen_layout.dart';
import 'package:instagram/presentation/widgets/belong_to/register_w/register_widgets.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_elevated_button.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final SharedPreferences sharePrefs;
  const LoginPage({Key? key, required this.sharePrefs}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final AppPreferences _appPreferences = injector<AppPreferences>();
  RxBool isHeMovedToHome = false.obs;
  ValueNotifier<bool> isToastShowed = ValueNotifier(false);
  ValueNotifier<bool> isUserIdReady = ValueNotifier(true);

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }

  @override
  dispose() {
    super.dispose();
    isToastShowed.dispose();
    isUserIdReady.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterWidgets(
      customTextButton: customTextButton(),
      emailController: emailController,
      passwordController: passwordController,
    );
  }

  Widget customTextButton() {
    return Builder(builder: (context) {
      FirestoreUserInfoCubit getUserCubit = FirestoreUserInfoCubit.get(context);

      return blocBuilder(getUserCubit);
    });
  }

  BlocBuilder<FirebaseAuthCubit, FirebaseAuthCubitState> blocBuilder(
      FirestoreUserInfoCubit getUserCubit) {
    return BlocBuilder<FirebaseAuthCubit, FirebaseAuthCubitState>(
      buildWhen: (previous, current) => true,
      builder: (context, authState) =>
          buildBlocBuilder(context, authState, getUserCubit),
    );
  }

  Widget buildBlocBuilder(context, FirebaseAuthCubitState authState,
      FirestoreUserInfoCubit getUserCubit) {
    return ValueListenableBuilder(
      valueListenable: isToastShowed,
      builder: (context, bool isToastShowedValue, child) {
        FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);
        if (authState is CubitAuthConfirmed) {
          onAuthConfirmed(getUserCubit, authCubit);
        } else if (authState is CubitAuthFailed && !isToastShowedValue) {
              isToastShowed.value = true;
              isUserIdReady.value = true;
              ToastShow.toastStateError(authState);
        }
        return loginButton(authCubit);
      },
    );
  }

  onAuthConfirmed(
      FirestoreUserInfoCubit getUserCubit, FirebaseAuthCubit authCubit) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserCubit.getUserInfo(authCubit.user!.uid);
      String userId = authCubit.user!.uid;
        isUserIdReady.value = true;
      if (!isHeMovedToHome.value) {
        myPersonalId = userId;
        if (myPersonalId.isNotEmpty) {
          await widget.sharePrefs.setString("myPersonalId", myPersonalId);
          Get.offAll(
            ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(myPersonalId),
              webScreenLayout: const WebScreenLayout(),
            ),
          );
        } else {
          ToastShow.toast(StringsManager.somethingWrong.tr());
        }
      }
      isHeMovedToHome.value = true;
    });
  }

  Widget loginButton(FirebaseAuthCubit authCubit) {
    return ValueListenableBuilder(
      valueListenable: isUserIdReady,
      builder: (context, bool isUserIdReadyValue, child) =>
          CustomElevatedButton(
        isItDone: isUserIdReadyValue,
        nameOfButton: StringsManager.logIn.tr(),
        onPressed: () async {
          isUserIdReady.value = false;
          isToastShowed.value = false;
          await authCubit.logIn(RegisteredUser(
              email: emailController.text, password: passwordController.text));
        },
      ),
    );
  }
}
