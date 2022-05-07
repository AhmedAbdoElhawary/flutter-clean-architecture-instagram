import 'package:flutter/material.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/styles_manager.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  const CustomTextField(
      {required this.controller, required this.hint, Key? key})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20,end: 20),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: ColorManager.teal,
        style: getNormalStyle( color:Theme.of(context).focusColor,fontSize: 15),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: Theme.of(context).indicatorColor),
          fillColor: const Color.fromRGBO(57, 57, 57, 0.03137254901960784),
          filled: true,
          focusedBorder: outlineInputBorder(),
          enabledBorder: outlineInputBorder(),
          contentPadding: const EdgeInsetsDirectional.only(start: 10,end: 10,bottom: 15,top: 15),
        ),
      ),
    );
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1.0),
    );
  }
}
