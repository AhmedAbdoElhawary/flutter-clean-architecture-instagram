import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SmarterRefresh extends StatefulWidget {
  final Widget smartRefresherChild;
  final AsyncValueGetter<void> onRefreshData;
  const SmarterRefresh(
      {required this.onRefreshData,
      required this.smartRefresherChild,
      Key? key})
      : super(key: key);

  @override
  State<SmarterRefresh> createState() => _SmarterRefreshState();
}

class _SmarterRefreshState extends State<SmarterRefresh>
    with TickerProviderStateMixin {
  late AnimationController _aniController, _scaleController;
  late AnimationController _footerController;
  final RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    _aniController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _scaleController =
        AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
    _footerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _refreshController.headerMode!.addListener(() {
      if (_refreshController.headerStatus == RefreshStatus.idle) {
        _scaleController.value = 0.0;
        _aniController.reset();
      } else if (_refreshController.headerStatus == RefreshStatus.refreshing) {
        _aniController.repeat();
      }
    });
    super.initState();
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
    return SizedBox(
      height: double.maxFinite,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        scrollDirection: Axis.vertical,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 2000));
          widget.onRefreshData().whenComplete(() {
            _refreshController.refreshCompleted();
            setState(() {});
          });
        },
        onLoading: () async {
          await Future.delayed(const Duration(milliseconds: 1000));
          setState(() {});
          _refreshController.loadComplete();
        },
        child: widget.smartRefresherChild,
        footer: CustomFooter(
          onModeChange: (mode) {
            if (mode == LoadStatus.loading) {
              _scaleController.value = 0.0;
              _footerController.repeat();
            } else {
              _footerController.reset();
            }
          },
          builder: (context, mode) {
            Widget child;
            switch (mode) {
              case LoadStatus.failed:
                child = Text(StringsManager.clickRetry.tr());
                break;
              case LoadStatus.noMore:
                child =  Text(StringsManager.noMoreData.tr());
                break;
              default:
                child = const CircularProgressIndicator(
                    strokeWidth: 1.5, color: ColorManager.white);
                break;
            }
            return SizedBox(
              height: 60,
              child: Center(
                child: child,
              ),
            );
          },
        ),
        header: CustomHeader(
          refreshStyle: RefreshStyle.Behind,
          onOffsetChange: (offset) {
            if (_refreshController.headerMode!.value !=
                RefreshStatus.refreshing) {
              _scaleController.value = offset / 100.0;
            }
          },
          builder: (__, _) {
            return Container(
              child: FadeTransition(
                opacity: _scaleController,
                child: ScaleTransition(
                  child:   const CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: ColorManager.black38,
                    backgroundColor: ColorManager.black12,
                  ),
                  scale: _scaleController,
                ),
              ),
              alignment: Alignment.center,
            );
          },
        ),
      ),
    );
  }
}
