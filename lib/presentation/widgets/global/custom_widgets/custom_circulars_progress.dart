import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/utility/constant.dart';

class CustomCircularProgress extends StatelessWidget {
  final Color color;

  const CustomCircularProgress(this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: Transform.scale(
        scale: 0.50,
        child: ClipOval(
          child: isThatAndroid
              ? CircularProgressIndicator(
                  strokeWidth: 6,
                  color: color,
                )
              : CupertinoActivityIndicator(color: color),
        ),
      ),
    );
  }
}

class ThineCircularProgress extends StatelessWidget {
  final Color? color;
  const ThineCircularProgress({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isThatAndroid
          ? CircularProgressIndicator(
              strokeWidth: 1, color: color ?? Theme.of(context).focusColor)
          : CupertinoActivityIndicator(
              color: color ?? Theme.of(context).focusColor),
    );
  }
}
