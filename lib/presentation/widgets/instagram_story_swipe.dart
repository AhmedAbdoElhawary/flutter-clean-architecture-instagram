import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class InstagramStorySwipe extends StatefulWidget {
  final List<Widget> children;
  final int initialPage;

  InstagramStorySwipe({
    required this.children,
    this.initialPage = 0,
  }) {
    assert(children.isNotEmpty);
  }

  @override
  _InstagramStorySwipeState createState() => _InstagramStorySwipeState();
}

class _InstagramStorySwipeState extends State<InstagramStorySwipe> {
  late PageController _pageController;
  double currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.children.length,

      itemBuilder: (context, index) {
        double value;
        if (_pageController.position.haveDimensions == false) {
          value = index.toDouble();
        } else {
          value = _pageController.page!;
        }
        return _SwipeWidget(
          index: index,
          pageNotifier: value,
          child: widget.children[index],
        );
      },
    );
  }
}

num degToRad(num deg) => deg * (pi / 180.0);

class _SwipeWidget extends StatelessWidget {
  final int index;

  final double pageNotifier;

  final Widget child;

  const _SwipeWidget({
    Key? key,
    required this.index,
    required this.pageNotifier,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLeaving = (index - pageNotifier) <= 0;
    final t = (index - pageNotifier);
    final rotationY = lerpDouble(0, 90, t);
    final opacity = lerpDouble(0, 1, t.abs())!.clamp(0.0, 1.0);
    final transform = Matrix4.identity();
    transform.setEntry(3, 2, 0.001);
    transform.rotateY(-degToRad(rotationY!).toDouble());
    return Transform(
      alignment: isLeaving ? Alignment.centerRight : Alignment.centerLeft,
      transform: transform,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: Opacity(
              opacity: opacity,
              child: const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
