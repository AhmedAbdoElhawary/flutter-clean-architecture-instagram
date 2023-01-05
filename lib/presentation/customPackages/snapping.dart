import 'dart:math';

import 'package:flutter/material.dart';

enum SelectedItemAnchor { start, middle, end }

class ScrollSnapList extends StatefulWidget {
  final Color? background;

  final Widget Function(BuildContext, int) itemBuilder;

  final Curve curve;

  final int duration;

  final double? endOfListTolerance;

  final bool focusOnItemTap;

  final void Function(int)? focusToItem;

  final EdgeInsetsGeometry? margin;

  final int itemCount;

  final double itemSize;

  @override
  // ignore: overridden_fields
  final Key? key;

  final Key? listViewKey;

  final void Function(int) onItemFocus;

  final Function? onReachEnd;

  final EdgeInsetsGeometry? padding;

  final bool reverse;

  final bool? updateOnScroll;

  final double? initialIndex;

  final Axis scrollDirection;

  final ScrollController listController;

  final bool dynamicItemSize;

  final double Function(double distance)? dynamicSizeEquation;

  final double? dynamicItemOpacity;

  final SelectedItemAnchor selectedItemAnchor;

  final bool shrinkWrap;

  final ScrollPhysics? scrollPhysics;

  final Clip clipBehavior;

  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  final bool allowAnotherDirection;

  final bool dispatchScrollNotifications;

  final EdgeInsetsGeometry? listViewPadding;

  ScrollSnapList(
      {this.background,
      required this.itemBuilder,
      ScrollController? listController,
      this.curve = Curves.ease,
      this.allowAnotherDirection = true,
      this.duration = 500,
      this.endOfListTolerance,
      this.focusOnItemTap = true,
      this.focusToItem,
      required this.itemCount,
      required this.itemSize,
      this.key,
      this.listViewKey,
      this.margin,
      required this.onItemFocus,
      this.onReachEnd,
      this.padding,
      this.reverse = false,
      this.updateOnScroll,
      this.initialIndex,
      this.scrollDirection = Axis.horizontal,
      this.dynamicItemSize = false,
      this.dynamicSizeEquation,
      this.dynamicItemOpacity,
      this.selectedItemAnchor = SelectedItemAnchor.middle,
      this.shrinkWrap = false,
      this.scrollPhysics,
      this.clipBehavior = Clip.hardEdge,
      this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
      this.dispatchScrollNotifications = false,
      this.listViewPadding})
      : listController = listController ?? ScrollController(),
        super(key: key);

  @override
  ScrollSnapListState createState() => ScrollSnapListState();
}

class ScrollSnapListState extends State<ScrollSnapList> {
  bool isInit = true;

  int previousIndex = -1;

  double currentPixel = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialIndex != null) {
        focusToInitialPosition();
      } else {
        isInit = false;
      }
    });

    Future.delayed(const Duration(milliseconds: 10), () {
      if (mounted) {
        setState(() {
          isInit = false;
        });
      }
    });
  }

  void _animateScroll(double location) {
    Future.delayed(Duration.zero, () {
      widget.listController.animateTo(
        location,
        duration: Duration(milliseconds: widget.duration),
        curve: widget.curve,
      );
    });
  }

  double calculateScale(int index) {
    double intendedPixel = index * widget.itemSize;
    double difference = intendedPixel - currentPixel;

    if (widget.dynamicSizeEquation != null) {
      double scale = widget.dynamicSizeEquation!(difference);
      return scale < 0 ? 0 : scale;
    }

    return 1 - min(difference.abs() / 500, 0.45);
  }

  double calculateOpacity(int index) {
    double intendedPixel = index * widget.itemSize;
    double difference = intendedPixel - currentPixel;

    return (difference == 0) ? 1.0 : widget.dynamicItemOpacity ?? 1.0;
  }

  Widget _buildListItem(BuildContext context, int index) {
    Widget child;
    if (widget.dynamicItemSize) {
      child = Transform.scale(
        scale: calculateScale(index),
        child: widget.itemBuilder(context, index),
      );
    } else {
      child = widget.itemBuilder(context, index);
    }

    if (widget.dynamicItemOpacity != null) {
      child = Opacity(opacity: calculateOpacity(index), child: child);
    }

    if (widget.focusOnItemTap) {
      return GestureDetector(onTap: () => focusToItem(index), child: child);
    }

    return child;
  }

  double _calcCardLocation(
      {double? pixel, required double itemSize, int? index}) {
    int cardIndex = index ?? ((pixel! - itemSize / 2) / itemSize).ceil();

    if (cardIndex < 0) {
      cardIndex = 0;
    } else if (cardIndex > widget.itemCount - 1) {
      cardIndex = widget.itemCount - 1;
    }

    if (cardIndex != previousIndex) {
      previousIndex = cardIndex;
      widget.onItemFocus(cardIndex);
    }

    return (cardIndex * itemSize);
  }

  void focusToItem(int index) {
    double targetLoc =
        _calcCardLocation(index: index, itemSize: widget.itemSize);
    _animateScroll(targetLoc);
  }

  void focusToInitialPosition() {
    widget.listController.jumpTo((widget.initialIndex! * widget.itemSize));
  }

  void _onReachEnd() {
    if (widget.onReachEnd != null) widget.onReachEnd!();
  }

  @override
  void dispose() {
    widget.listController.dispose();
    super.dispose();
  }

  double calculateListPadding(BoxConstraints constraint) {
    switch (widget.selectedItemAnchor) {
      case SelectedItemAnchor.middle:
        return (widget.scrollDirection == Axis.horizontal
                    ? constraint.maxWidth
                    : constraint.maxHeight) /
                2 -
            widget.itemSize / 2;
      case SelectedItemAnchor.end:
        return (widget.scrollDirection == Axis.horizontal
                ? constraint.maxWidth
                : constraint.maxHeight) -
            widget.itemSize;
      case SelectedItemAnchor.start:
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraint) {
          double listPadding = calculateListPadding(constraint);

          return GestureDetector(
            onTapDown: (_) {},
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.depth > 0) {
                  return false;
                }

                if (!widget.allowAnotherDirection) {
                  if (scrollInfo.metrics.axisDirection == AxisDirection.right ||
                      scrollInfo.metrics.axisDirection == AxisDirection.left) {
                    if (widget.scrollDirection != Axis.horizontal) {
                      return false;
                    }
                  }

                  if (scrollInfo.metrics.axisDirection == AxisDirection.up ||
                      scrollInfo.metrics.axisDirection == AxisDirection.down) {
                    if (widget.scrollDirection != Axis.vertical) {
                      return false;
                    }
                  }
                }

                if (scrollInfo is ScrollEndNotification) {
                  if (isInit) {
                    return true;
                  }

                  double tolerance =
                      widget.endOfListTolerance ?? (widget.itemSize / 2);
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - tolerance) {
                    _onReachEnd();
                  }

                  double offset = _calcCardLocation(
                    pixel: scrollInfo.metrics.pixels,
                    itemSize: widget.itemSize,
                  );

                  if ((scrollInfo.metrics.pixels - offset).abs() > 0.01) {
                    _animateScroll(offset);
                  }
                } else if (scrollInfo is ScrollUpdateNotification) {
                  if (widget.dynamicItemSize ||
                      widget.dynamicItemOpacity != null) {
                    setState(() {
                      currentPixel = scrollInfo.metrics.pixels;
                    });
                  }

                  if (widget.updateOnScroll == true) {
                    if (isInit) {
                      return true;
                    }

                    if (isInit == false) {
                      _calcCardLocation(
                        pixel: scrollInfo.metrics.pixels,
                        itemSize: widget.itemSize,
                      );
                    }
                  }
                }
                return !widget.dispatchScrollNotifications;
              },
              child: ListView.builder(
                key: widget.listViewKey,
                controller: widget.listController,
                clipBehavior: widget.clipBehavior,
                keyboardDismissBehavior: widget.keyboardDismissBehavior,
                padding: widget.listViewPadding ??
                    (widget.scrollDirection == Axis.horizontal
                        ? EdgeInsets.symmetric(horizontal: max(0, listPadding))
                        : EdgeInsets.symmetric(vertical: max(0, listPadding))),
                reverse: widget.reverse,
                scrollDirection: widget.scrollDirection,
                itemBuilder: _buildListItem,
                itemCount: widget.itemCount,
                shrinkWrap: widget.shrinkWrap,
                physics: widget.scrollPhysics,
              ),
            ),
          );
        },
      ),
    );
  }
}
