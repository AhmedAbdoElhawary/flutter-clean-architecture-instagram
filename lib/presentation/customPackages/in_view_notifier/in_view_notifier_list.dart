import 'package:flutter/material.dart';
import 'in_view_notifier.dart';
import 'in_view_state.dart';
import 'widget_data.dart';

class InViewNotifierList extends InViewNotifier {
  InViewNotifierList({
    super.key,
    int? itemCount,
    required IndexedWidgetBuilder builder,
    super.initialInViewIds,
    super.endNotificationOffset,
    super.onListEndReached,
    super.throttleDuration,
    Axis scrollDirection = Axis.vertical,
    required super.isInViewPortCondition,
    ScrollController? controller,
    EdgeInsets? padding,
    ScrollPhysics? physics,
    bool reverse = false,
    required super.postsIds,
    required super.onRefreshData,
    required super.isThatEndOfList,
    bool? primary,
    bool shrinkWrap = false,
    bool addAutomaticKeepAlive = true,
  })  : assert(endNotificationOffset >= 0.0),
        super(
          child: ListView.builder(
            padding: padding,
            controller: controller,
            scrollDirection: scrollDirection,
            physics: physics,
            reverse: reverse,
            primary: primary,
            addAutomaticKeepAlives: addAutomaticKeepAlive,
            shrinkWrap: shrinkWrap,
            itemCount: itemCount,
            itemBuilder: builder,
          ),
        );

  static InViewState? of(BuildContext context) {
    final InheritedInViewWidget widget =
        context.getElementForInheritedWidgetOfExactType<InheritedInViewWidget>()!.widget as InheritedInViewWidget;
    return widget.inViewState;
  }
}
