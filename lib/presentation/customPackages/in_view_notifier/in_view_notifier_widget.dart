import 'package:flutter/material.dart';
import 'in_view_notifier_list.dart';
import 'in_view_state.dart';

class InViewNotifierWidget extends StatefulWidget {
  final String id;
  final InViewNotifierWidgetBuilder builder;
  final Widget? child;

  const InViewNotifierWidget({
    Key? key,
    required this.id,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  InViewNotifierWidgetState createState() => InViewNotifierWidgetState();
}

class InViewNotifierWidgetState extends State<InViewNotifierWidget> {
  late final InViewState state;

  @override
  void initState() {
    super.initState();
    state = InViewNotifierList.of(context)!;
    state.addContext(context: context, id: widget.id);
  }

  @override
  void dispose() {
    state.removeContext(context: context);
    super.dispose();
  }

  @override
  void didUpdateWidget(InViewNotifierWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      state.removeContext(context: context);
      state.addContext(context: context, id: widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final bool isInView = state.inView(widget.id);

        return widget.builder(context, isInView, child);
      },
    );
  }
}

typedef InViewNotifierWidgetBuilder = Widget Function(
  BuildContext context,
  bool isInView,
  Widget? child,
);
