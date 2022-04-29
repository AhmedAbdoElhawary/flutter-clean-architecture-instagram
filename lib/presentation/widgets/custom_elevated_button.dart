import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      child: ElevatedButton(
          style: buttonStyle(),
          onPressed: () async => onPressed(),
          child: isItDone ? textOfButton() : circularProgress()),
    );
  }

  Padding textOfButton() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Text(
        nameOfButton,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Padding circularProgress() {
    return const Padding(
      padding: EdgeInsets.all(3.0),
      child: ClipOval(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 140.0)),
        backgroundColor: MaterialStateProperty.all<Color>(
            isItDone ? Colors.blue : const Color.fromARGB(255, 127, 193, 255)));
  }
}
