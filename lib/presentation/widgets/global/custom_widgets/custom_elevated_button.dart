import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';

class CustomElevatedButton extends StatefulWidget {
  final String nameOfButton;
  final bool isItDone;
  final bool blueColor;
  final AsyncCallback onPressed;
  const CustomElevatedButton(
      {Key? key,
      required this.isItDone,
      this.blueColor = true,
      required this.nameOfButton,
      required this.onPressed})
      : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => widget.onPressed(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
            margin: const EdgeInsetsDirectional.all(3.0),
            padding: const EdgeInsetsDirectional.all(15.0),
            width: double.infinity,
            decoration: containerStyle(),
            child: widget.isItDone ? textOfButton() : circularProgress()),
      ),
    );
  }

  Padding textOfButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.all(1.5),
      child: Center(
        child: Text(
          widget.nameOfButton,
          style: getNormalStyle(color: ColorManager.white),
        ),
      ),
    );
  }

  Widget circularProgress() {
    return const Center(
      child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
              color: ColorManager.white, strokeWidth: 2)),
    );
  }

  BoxDecoration containerStyle() {
    return BoxDecoration(
      color: !widget.blueColor
          ? ColorManager.lightBlue
          : (widget.isItDone ? ColorManager.blue : ColorManager.lightBlue),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: ColorManager.grey.withOpacity(.2),
          blurRadius: 5,
          spreadRadius: 5,
          offset: const Offset(0.0, 1.0),
        ),
      ],
    );
  }
}
