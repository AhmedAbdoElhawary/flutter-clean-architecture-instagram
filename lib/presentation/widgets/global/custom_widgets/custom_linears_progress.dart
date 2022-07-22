import 'package:flutter/material.dart';

class ThineLinearProgress extends StatelessWidget {
  const ThineLinearProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
        minHeight: 1, color: Theme.of(context).focusColor);
  }
}
