import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  const FadeAnimation(
      {Key? key,
      required this.child,
      this.duration = const Duration(milliseconds: 1500)})
      : super(key: key);

  final Widget child;
  final Duration duration;

  @override
  FadeAnimationState createState() => FadeAnimationState();
}

class FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();

    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => animationController.isAnimating
      ? AnimatedBuilder(
          animation: animationController,
          builder: (context, child) => AnimatedOpacity(
            opacity: 1.0 - animationController.value,
            duration: const Duration(milliseconds: 10),
            child: widget.child,
          ),
        )
      : Container();
}
