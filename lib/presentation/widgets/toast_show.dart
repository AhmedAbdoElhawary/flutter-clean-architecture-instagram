import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastShow {
  static toast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }
  static toastStateError(dynamic state){
    String error;
    try {
      error = state.error.split(RegExp(r']'))[1];
    } catch (e) {
      error = state.error;
    }
    ToastShow.toast(error);
  }
}