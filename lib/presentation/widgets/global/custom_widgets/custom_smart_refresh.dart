import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomSmartRefresh extends StatefulWidget {
  final AsyncValueSetter<int> onRefreshData;
  final Widget child;
  const CustomSmartRefresh(
      {Key? key, required this.onRefreshData, required this.child})
      : super(key: key);

  @override
  State<CustomSmartRefresh> createState() => _CustomSmartRefreshState();
}

class _CustomSmartRefreshState extends State<CustomSmartRefresh>
    with TickerProviderStateMixin {
  late AnimationController _aniController, _scaleController, _footerController;
  final _refreshController = ValueNotifier(RefreshController());
  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    _aniController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _scaleController =
        AnimationController(value: 1, vsync: this, upperBound: 1);
    _footerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _refreshController.value.headerMode!.addListener(() {
      if (_refreshController.value.headerStatus == RefreshStatus.idle) {
        _scaleController.value = 0.0;
        _aniController.reset();
      } else if (_refreshController.value.headerStatus ==
          RefreshStatus.refreshing) {
        _aniController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scaleController.dispose();
    _footerController.dispose();
    _aniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _refreshController,
      builder: (_, RefreshController value, __) {
        return SmartRefresher(
          enablePullUp: false,
          enablePullDown: true,
          enableTwoLevel: false,
          controller: value,
          scrollDirection: Axis.vertical,
          onRefresh: onSmarterRefresh,
          header: customHeader(),
          child: widget.child,
        );
      },
    );
  }

  onSmarterRefresh() {
    widget.onRefreshData(0).whenComplete(() {
      _refreshController.value.refreshCompleted();
      _refreshController.value.loadComplete();
    });
  }

  CustomHeader customHeader() {
    return CustomHeader(
      refreshStyle: RefreshStyle.Behind,
      onOffsetChange: (offset) {
        if (_refreshController.value.headerMode!.value !=
            RefreshStatus.refreshing) {
          _scaleController.value = offset / 150.0;
        }
      },
      builder: (context, mode) {
        return customCircleProgress(context);
      },
    );
  }

  Container customCircleProgress(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _scaleController,
        child: const ThineCircularProgress(),
      ),
    );
  }
}
