import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/core/app_prefs.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:instegram/core/utility/constant.dart';
import 'package:instegram/domain/entities/registered_user.dart';
import 'package:instegram/core/utility/injector.dart';
import 'package:instegram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instegram/presentation/screens/main_screen.dart';
import 'package:instegram/presentation/widgets/custom_elevated_button.dart';
import 'package:instegram/presentation/widgets/register_widgets.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final SharedPreferences sharePrefs;

  const LoginPage({Key? key,required this.sharePrefs}) : super(key: key);

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
    return RegisterWidgets(
      confirmPasswordController: TextEditingController(text: ""),
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

  buildBlocBuilder(context, FirebaseAuthCubitState authState,
      FirestoreUserInfoCubit getUserCubit) {
    FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);
    if (authState is CubitAuthConfirmed) {
      onAuthConfirmed(getUserCubit, authCubit);
    } else if (authState is CubitAuthFailed) {
      setState(() {
        isUserIdReady = true;
      });

      ToastShow.toastStateError(authState);
    }
    return loginButton(authCubit);
  }

  onAuthConfirmed(
      FirestoreUserInfoCubit getUserCubit, FirebaseAuthCubit authCubit) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async{
      await getUserCubit.getUserInfo(authCubit.user!.uid);
      String userId = authCubit.user!.uid;
      setState(() {
        isUserIdReady = true;
      });
    if (!isHeMovedToHome) {
      myPersonalId = userId;
      await widget.sharePrefs.setString("myPersonalId", userId);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainScreen(myPersonalId)));
    }
    isHeMovedToHome = true;
    });

  }

  CustomElevatedButton loginButton(FirebaseAuthCubit authCubit) {
    return CustomElevatedButton(
      isItDone: isUserIdReady,
      nameOfButton: StringsManager.logIn.tr(),
      onPressed: () async {
        isUserIdReady = false;
        await authCubit.logIn(RegisteredUser(
            email: emailController.text, password: passwordController.text));
      },
    );
  }
}
