import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LikePopupAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool isAnimating;
  final VoidCallback onEnd;
  const LikePopupAnimation({
    required this.child,
    required this.onEnd,
    this.duration = const Duration(milliseconds: 150),
    required this.isAnimating,
    Key? key,
  }) : super(key: key);

  @override
  State<LikePopupAnimation> createState() => _LikePopupAnimationState();
}

class _LikePopupAnimationState extends State<LikePopupAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;
  @override
  void initState() {
    super.initState();
    final halfDuration = widget.duration.inMilliseconds ~/ 2;
    animationController = AnimationController(
        duration: Duration(milliseconds: halfDuration), vsync: this);
    scale = Tween<double>(begin: 1, end: 1.2).animate(animationController);
  }

  @override
  void didUpdateWidget(LikePopupAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      doAnimation();
    }
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  Future doAnimation() async {
    if (widget.isAnimating) {
      await animationController.forward();
      await animationController.reverse();
      await Future.delayed(const Duration(milliseconds: 400));
      if (kDebugMode) {
        print("remove animation :");
      }
      widget.onEnd();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
