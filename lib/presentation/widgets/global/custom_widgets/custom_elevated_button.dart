import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';

class CustomElevatedButton extends StatefulWidget {
  final String nameOfButton;
  final bool isItDone;
  final AsyncCallback onPressed;
  const CustomElevatedButton(
      {Key? key,
      required this.isItDone,
      required this.nameOfButton,
      required this.onPressed})
      : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.all(3.0),
      padding: const EdgeInsetsDirectional.all(20.0),
      width: double.infinity,
      child: ElevatedButton(
          style: buttonStyle(),
          onPressed: () async => widget.onPressed(),
          child: widget.isItDone ? textOfButton() : circularProgress()),
    );
  }

  Padding textOfButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.all(3.0),
      child: Text(
        widget.nameOfButton,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  Widget circularProgress() {
    return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
            color: ColorManager.white, strokeWidth: 2));
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            widget.isItDone ? ColorManager.blue : ColorManager.lightBlue));
  }
}
