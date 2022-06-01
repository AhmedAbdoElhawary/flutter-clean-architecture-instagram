import 'package:flutter/material.dart';

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
          child: CircularProgressIndicator(
            strokeWidth: 6,
            color: color,
          ),
        ),
      ),
    );
  }
}

class ThineCircularProgress extends StatelessWidget {
  const ThineCircularProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
          strokeWidth: 1, color: Theme.of(context).focusColor),
    );
  }
}
