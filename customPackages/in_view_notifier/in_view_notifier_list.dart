import 'package:flutter/material.dart';
import 'in_view_notifier.dart';
import 'in_view_state.dart';
import 'package:flutter/foundation.dart';
import 'widget_data.dart';

class InViewNotifierList extends InViewNotifier {
  InViewNotifierList({
    Key? key,
    int? itemCount,
    required IndexedWidgetBuilder builder,
    List<String> initialInViewIds = const [],
    double endNotificationOffset = 0.0,
    VoidCallback? onListEndReached,
    Duration throttleDuration = const Duration(milliseconds: 200),
    Axis scrollDirection = Axis.vertical,
    required IsInViewPortCondition isInViewPortCondition,
    ScrollController? controller,
    EdgeInsets? padding,
    ScrollPhysics? physics,
    bool reverse = false,
    required List postsIds,
    required AsyncValueSetter<int> onRefreshData,
    required ValueNotifier<bool> isThatEndOfList,
    bool? primary,
    bool shrinkWrap = false,
    bool addAutomaticKeepAlive = true,
  })  : assert(endNotificationOffset >= 0.0),
        super(
          key: key,
          initialInViewIds: initialInViewIds,
          endNotificationOffset: endNotificationOffset,
          onListEndReached: onListEndReached,
          throttleDuration: throttleDuration,
          onRefreshData: onRefreshData,
          postsIds: postsIds,
          isThatEndOfList: isThatEndOfList,
          isInViewPortCondition: isInViewPortCondition,
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
    final InheritedInViewWidget widget = context
        .getElementForInheritedWidgetOfExactType<InheritedInViewWidget>()!
        .widget as InheritedInViewWidget;
    return widget.inViewState;
  }
}
