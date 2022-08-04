// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'in_view_state.dart';

class WidgetData {
  final BuildContext? context;
  final String id;

  WidgetData({required this.context, required this.id});

  @override
  String toString() {
    return "${describeIdentity(this)} id=$id";
  }
}

class InheritedInViewWidget extends InheritedWidget {
  final InViewState? inViewState;
  // ignore: annotate_overrides
  final Widget child;

  const InheritedInViewWidget({Key? key, this.inViewState, required this.child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedInViewWidget oldWidget) => false;
}
