import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/presentation/pages/register/sign_up_page.dart';
import 'package:instagram/presentation/widgets/belong_to/register_w/or_text.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_text_field.dart';

class RegisterWidgets extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Widget customTextButton;
  final bool isThatLogIn;
  const RegisterWidgets({
    Key? key,
    required this.emailController,
    this.isThatLogIn = true,
    required this.passwordController,
    required this.customTextButton,
    required this.confirmPasswordController,
  }) : super(key: key);

  @override
  State<RegisterWidgets> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<RegisterWidgets> {
  // final AppPreferences _appPreferences = injector<AppPreferences>();
  //
  // @override
  // void didChangeDependencies() {
  //   _appPreferences.getLocal().then((local) => {context.setLocale(local)});
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
                color: Theme.of(context).focusColor,
                height: 50,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                  hint: StringsManager.phoneOrEmailOrUserName.tr(),
                  controller: widget.emailController),
              const SizedBox(height: 15),
              CustomTextField(
                  hint: StringsManager.password.tr(),
                  controller: widget.passwordController),
              if (!widget.isThatLogIn) ...[
                const SizedBox(height: 15),
                //---------------------------------------------
                CustomTextField(
                    hint: StringsManager.confirmPassword.tr(),
                    controller: widget.confirmPasswordController),
                //---------------------------------------------
              ],
              const SizedBox(height: 15),
              widget.customTextButton,
              const SizedBox(height: 15),
              haveAccountRow(context),
              const SizedBox(height: 8),
              const OrText(),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    StringsManager.loginWithFacebook.tr(),
                    style: getNormalStyle(color: ColorManager.blue),
                  ))
            ],
          ),
        )),
      ),
    );
  }

  Row haveAccountRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.isThatLogIn
              ? StringsManager.noAccount.tr()
              : StringsManager.haveAccount.tr(),
          style: getNormalStyle(
              fontSize: 13, color: Theme.of(context).bottomAppBarColor),
        ),
        login(context),
      ],
    );
  }

  InkWell login(BuildContext context) {
    return InkWell(
        onTap: () {
          if (widget.isThatLogIn) {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => const SignUpPage()));
          } else {
            Navigator.pop(context);
          }
        },
        child: loginText());
  }

  Text loginText() {
    return Text(
      widget.isThatLogIn
          ? StringsManager.signUp.tr()
          : StringsManager.logIn.tr(),
      style: getBoldStyle(fontSize: 13, color: Theme.of(context).focusColor),
    );
  }
}
