import 'package:flutter/material.dart';

class ThineLinearProgress extends StatelessWidget {
  const ThineLinearProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
        minHeight: 1, color: Theme.of(context).focusColor);
  }
}
