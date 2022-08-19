import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool? isThatEmail;
  bool validate;

   CustomTextField(
      {required this.controller,
      required this.hint,
      this.isThatEmail,
      this.validate = false,
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
      setState(() {
        if (widget.controller.text.isNotEmpty) {
          errorMassage = widget.isThatEmail != null
              ? (widget.isThatEmail == true
                  ? _validateEmail()
                  : _validatePassword())
              : null;
        } else {
          widget.validate=false;

          errorMassage = null;
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
      child: SizedBox(
        height: isThatMobile ? null : 37,
        width: double.infinity,
        child: TextFormField(
          controller: widget.controller,
          cursorColor: ColorManager.teal,
          style:
              getNormalStyle(color: Theme.of(context).focusColor, fontSize: 15),
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
            errorText: errorMassage,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 10, vertical: isThatMobile ? 15 : 5),
          ),
        ),
      ),
    );
  }

  String? _validateEmail() {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regex.hasMatch(widget.controller.text)) {
      widget.validate=true;
      return 'Please make sure your email address is valid';
    } else {
      widget.validate=false;

      return null;
    }
  }

  String? _validatePassword() {
    if (widget.controller.text.length < 6) {
      widget.validate=true;

      return 'Password must be at least 6 characters';
    } else {
      widget.validate=false;

      return null;
    }
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(isThatMobile ? 5.0 : 1.0),
      borderSide: BorderSide(
          color: ColorManager.lightGrey, width: isThatMobile ? 1.0 : 0.3),
    );
  }
}
