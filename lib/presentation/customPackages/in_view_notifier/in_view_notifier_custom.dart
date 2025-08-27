import 'package:flutter/material.dart';
import 'in_view_notifier.dart';
import 'in_view_state.dart';
import 'widget_data.dart';

class InViewNotifierCustomScrollView extends InViewNotifier {
  InViewNotifierCustomScrollView({
    super.key,
    required List<Widget> slivers,
    super.initialInViewIds,
    super.endNotificationOffset,
    super.onListEndReached,
    super.throttleDuration,
    Axis scrollDirection = Axis.vertical,
    required super.isInViewPortCondition,
    ScrollController? controller,
    ScrollPhysics? physics,
    required super.postsIds,
    required super.onRefreshData,
    required super.isThatEndOfList,
    bool reverse = false,
    bool? primary,
    bool shrinkWrap = false,
    Key? center,
    double anchor = 0.0,
  }) : super(
          child: CustomScrollView(
            slivers: slivers,
            anchor: anchor,
            controller: controller,
            scrollDirection: scrollDirection,
            physics: physics,
            reverse: reverse,
            primary: primary,
            shrinkWrap: shrinkWrap,
            center: center,
          ),
        );

  static InViewState? of(BuildContext context) {
    final InheritedInViewWidget widget =
        context.getElementForInheritedWidgetOfExactType<InheritedInViewWidget>()!.widget as InheritedInViewWidget;
    return widget.inViewState;
  }
}
