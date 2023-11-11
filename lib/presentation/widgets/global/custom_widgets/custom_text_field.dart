import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool? isThatEmail;
  final ValueNotifier<bool>? validate;
  final bool isThatLogin;
  const CustomTextField(
      {required this.controller,
      required this.hint,
      required this.isThatLogin,
      this.isThatEmail,
      this.validate,
      Key? key})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? errorMassage;
  @override
  void initState() {
    widget.controller.addListener(() {
      if (widget.controller.text.isNotEmpty) {
        errorMassage = widget.isThatEmail != null
            ? (widget.isThatEmail == true
                ? _validateEmail()
                : _validatePassword())
            : null;
      } else {
        errorMassage = null;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: isThatMobile ? null : 37,
        width: double.infinity,
        child: BlocConsumer<FirebaseAuthCubit, FirebaseAuthCubitState>(
          bloc: FirebaseAuthCubit.get(context)
            ..isThisEmailToken(email: widget.controller.text),
          listenWhen: (previous, current) =>
              previous != current && current is CubitEmailVerificationLoaded,
          listener: (context, state) {
            if (!widget.isThatLogin) {
              if (state is CubitEmailVerificationLoaded &&
                  state.isThisEmailToken &&
                  widget.isThatEmail == true) {
                errorMassage = "This email already exists.";
                widget.validate?.value = false;
              } else if (widget.isThatEmail == true) {
                errorMassage = null;
                widget.validate?.value = true;
              }
            }
          },
          buildWhen: (previous, current) =>
              previous != current && current is CubitEmailVerificationLoaded,
          builder: (context, state) {
            return TextFormField(
              controller: widget.controller,
              cursorColor: ColorManager.teal,
              style: getNormalStyle(
                  color: Theme.of(context).focusColor, fontSize: 15),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: isThatMobile
                    ? getNormalStyle(color: Theme.of(context).indicatorColor)
                    : getNormalStyle(color: ColorManager.black54, fontSize: 12),
                fillColor: const Color.fromARGB(48, 232, 232, 232),
                filled: true,
                focusedBorder: outlineInputBorder(),
                enabledBorder: outlineInputBorder(),
                errorStyle: getNormalStyle(color: ColorManager.red),
                errorText: isThatMobile ? errorMassage : null,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: isThatMobile ? 15 : 5),
              ),
            );
          },
        ),
      ),
    );
  }

  String? _validateEmail() {
    if (!widget.controller.text.isEmail) {
      setState(() => widget.validate!.value = false);
      return 'Please make sure your email address is valid';
    } else {
      setState(() => widget.validate!.value = true);
      return null;
    }
  }

  String? _validatePassword() {
    if (widget.controller.text.length < 6) {
      setState(() => widget.validate!.value = false);
      return 'Password must be at least 6 characters';
    } else {
      setState(() => widget.validate!.value = true);
      return null;
    }
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(isThatMobile ? 5.0 : 1.0),
      borderSide: BorderSide(
          color: ColorManager.lightGrey, width: isThatMobile ? 1.0 : 0.8),
    );
  }
}
