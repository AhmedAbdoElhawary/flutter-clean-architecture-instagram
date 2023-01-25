import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:instagram/core/functions/toast_show.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/domain/entities/registered_user.dart';
import 'package:instagram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instagram/presentation/pages/register/widgets/get_my_user_info.dart';
import 'package:instagram/presentation/pages/register/widgets/register_widgets.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SharedPreferences sharePrefs = injector<SharedPreferences>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxBool isHeMovedToHome = false.obs;
  ValueNotifier<bool> isToastShowed = ValueNotifier(false);
  ValueNotifier<bool> isUserIdReady = ValueNotifier(true);
  ValueNotifier<bool> validateEmail = ValueNotifier(false);
  ValueNotifier<bool> validatePassword = ValueNotifier(false);

  @override
  dispose() {
    super.dispose();
    isToastShowed.dispose();
    isUserIdReady.dispose();
    validateEmail.dispose();
    validatePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterWidgets(
      customTextButton: customTextButton(),
      emailController: emailController,
      passwordController: passwordController,
      validateEmail: validateEmail,
      validatePassword: validatePassword,
    );
  }

  Widget customTextButton() {
    return blocBuilder();
  }

  Widget blocBuilder() {
    return ValueListenableBuilder(
      valueListenable: isToastShowed,
      builder: (context, bool isToastShowedValue, child) =>
          BlocListener<FirebaseAuthCubit, FirebaseAuthCubitState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is CubitAuthConfirmed) {
            onAuthConfirmed(state);
          } else if (state is CubitAuthFailed && !isToastShowedValue) {
            isToastShowed.value = true;
            isUserIdReady.value = true;
            ToastShow.toastStateError(state);
          }
        },
        child: loginButton(),
      ),
    );
  }

  onAuthConfirmed(CubitAuthConfirmed state) async {
    String userId = state.user.uid;
    isUserIdReady.value = true;
    myPersonalId = userId;
    if (myPersonalId.isNotEmpty) {
      await sharePrefs.setString("myPersonalId", myPersonalId);
      Get.offAll(GetMyPersonalInfo(myPersonalId: myPersonalId));
    } else {
      ToastShow.toast(StringsManager.somethingWrong.tr);
    }
  }

  Widget loginButton() {
    FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);

    return ValueListenableBuilder(
      valueListenable: isUserIdReady,
      builder: (context, bool isUserIdReadyValue, child) =>
          ValueListenableBuilder(
        valueListenable: validateEmail,
        builder: (context, bool validateEmailValue, child) =>
            ValueListenableBuilder(
          valueListenable: validatePassword,
          builder: (context, bool validatePasswordValue, child) {
            bool validate = validatePasswordValue && validateEmailValue;

            return CustomElevatedButton(
              isItDone: isUserIdReadyValue,
              nameOfButton: StringsManager.logIn.tr,
              blueColor: validate,
              onPressed: () async {
                if (validate) {
                  isUserIdReady.value = false;
                  isToastShowed.value = false;
                  await authCubit.logIn(RegisteredUser(
                      email: emailController.text,
                      password: passwordController.text));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
