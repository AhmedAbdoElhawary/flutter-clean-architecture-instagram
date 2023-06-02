import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/pages/register/sign_up_page.dart';
import 'package:instagram/presentation/pages/register/widgets/or_text.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_text_field.dart';

class RegisterWidgets extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? fullNameController;
  final Widget customTextButton;
  final bool isThatLogIn;
  final ValueNotifier<bool> validateEmail;
  final ValueNotifier<bool> validatePassword;
  final ValueNotifier<bool>? rememberPassword;

  const RegisterWidgets({
    Key? key,
    required this.emailController,
    this.isThatLogIn = true,
    required this.passwordController,
    required this.customTextButton,
    this.fullNameController,
    this.rememberPassword,
    required this.validateEmail,
    required this.validatePassword,
  }) : super(key: key);

  @override
  State<RegisterWidgets> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<RegisterWidgets> {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 50;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: isThatMobile
              ? buildColumn(context, height: height)
              : buildForWeb(context),
        )),
      ),
    );
  }

  SizedBox buildForWeb(BuildContext context) {
    return SizedBox(
      width: 352,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.2),
            ),
            child: buildColumn(context),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.2),
            ),
            child: haveAccountRow(context),
          ),
        ],
      ),
    );
  }

  Widget buildColumn(BuildContext context, {double height = 400}) {
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.isThatLogIn) const Spacer(),
          SvgPicture.asset(
            IconsAssets.instagramLogo,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
            height: 50,
          ),
          const SizedBox(height: 30),
          CustomTextField(
            hint: StringsManager.email.tr,
            controller: widget.emailController,
            isThatEmail: true,
            validate: widget.validateEmail,
            isThatLogin: widget.isThatLogIn,
          ),
          SizedBox(height: isThatMobile ? 15 : 6.5),
          if (!widget.isThatLogIn && widget.fullNameController != null) ...[
            CustomTextField(
              hint: StringsManager.fullName.tr,
              controller: widget.fullNameController!,
              isThatLogin: widget.isThatLogIn,
            ),
            SizedBox(height: isThatMobile ? 15 : 6.5),
          ],
          CustomTextField(
            hint: StringsManager.password.tr,
            controller: widget.passwordController,
            isThatEmail: false,
            validate: widget.validatePassword,
            isThatLogin: widget.isThatLogIn,
          ),
          if (!widget.isThatLogIn) ...[
            if (!isThatMobile) const SizedBox(height: 10),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isThatMobile ? 4 : 0,
                    vertical: isThatMobile ? 15 : 0),
                child: Row(
                  children: [
                    const SizedBox(width: 13),
                    ValueListenableBuilder(
                      valueListenable: widget.rememberPassword!,
                      builder: (context, bool rememberPasswordValue, child) =>
                          Checkbox(
                              value: rememberPasswordValue,
                              activeColor: isThatMobile
                                  ? ColorManager.white
                                  : ColorManager.blue,
                              fillColor: isThatMobile
                                  ? MaterialStateProperty.resolveWith(
                                      (Set states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return Colors.blue.withOpacity(.32);
                                      }
                                      return Colors.blue;
                                    })
                                  : null,
                              onChanged: (value) => widget.rememberPassword!
                                  .value = !rememberPasswordValue),
                    ),
                    Text(
                      StringsManager.rememberPassword.tr,
                      style:
                          getNormalStyle(color: Theme.of(context).focusColor),
                    )
                  ],
                ),
              ),
            ),
            if (!isThatMobile) const SizedBox(height: 10),
          ],
          widget.customTextButton,
          const SizedBox(height: 15),
          if (!widget.isThatLogIn) ...[
            const Spacer(),
            const Spacer(),
          ],
          if (isThatMobile) ...[
            const SizedBox(height: 8),
            if (!widget.isThatLogIn) ...[
              const Divider(color: ColorManager.lightGrey, height: 1),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 15.0, right: 15.0, bottom: 6.5),
                child: haveAccountRow(context),
              ),
            ] else ...[
              haveAccountRow(context),
              const OrText(),
            ],
          ],
          if (widget.isThatLogIn) ...[
            TextButton(
              onPressed: () {},
              child: Text(
                StringsManager.loginWithFacebook.tr,
                style: getNormalStyle(color: ColorManager.blue),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Row haveAccountRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.isThatLogIn
              ? StringsManager.noAccount.tr
              : StringsManager.haveAccount.tr,
          style:
              getNormalStyle(fontSize: 13, color: Theme.of(context).focusColor),
        ),
        const SizedBox(width: 4),
        register(context),
      ],
    );
  }

  InkWell register(BuildContext context) {
    return InkWell(
        onTap: () {
          if (widget.isThatLogIn) {
            Get.to(const SignUpPage(),
                preventDuplicates: true,
                duration: const Duration(milliseconds: 0));
          } else {
            Get.back();
          }
        },
        child: registerText());
  }

  Text registerText() {
    return Text(
      widget.isThatLogIn ? StringsManager.signUp.tr : StringsManager.logIn.tr,
      style: getBoldStyle(fontSize: 13, color: ColorManager.blue),
    );
  }
}
