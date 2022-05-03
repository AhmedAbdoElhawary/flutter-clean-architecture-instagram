import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const CustomTextField(
      {required this.controller, required this.hint, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20,end: 20),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.teal,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38),
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
      borderSide: const BorderSide(color: Colors.black12, width: 1.0),
    );
  }
}
