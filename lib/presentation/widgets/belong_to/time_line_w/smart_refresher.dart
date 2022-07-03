import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SmarterRefresh extends StatefulWidget {
  final Widget child;
  final List posts;
  final ValueNotifier<bool> isThatEndOfList;
  final AsyncValueSetter<int> onRefreshData;
  const SmarterRefresh(
      {required this.onRefreshData,
      required this.child,
      required this.isThatEndOfList,
      required this.posts,
      Key? key})
      : super(key: key);

  @override
  State<SmarterRefresh> createState() => _SmarterRefreshState();
}

class _SmarterRefreshState extends State<SmarterRefresh>
    with TickerProviderStateMixin {
  late AnimationController _aniController, _scaleController;
  late AnimationController _footerController;
  final ValueNotifier<RefreshController> _refreshController =
      ValueNotifier(RefreshController());
  ValueNotifier<int> lengthOfPosts = ValueNotifier(5);
  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    _aniController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _scaleController =
        AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
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
    return SizedBox(
      height: double.maxFinite,
      child: ValueListenableBuilder(
        valueListenable: _refreshController,
        builder: (_, RefreshController value, __) {
          return smartRefresher(value);
        },
      ),
    );
  }

  SmartRefresher smartRefresher(RefreshController value) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: value,
      scrollDirection: Axis.vertical,
      onRefresh: onSmarterRefresh,
      onLoading: onSmarterLoading,
      child: widget.child,
      footer: customFooter(),
      header: customHeader(),
    );
  }

  onSmarterRefresh() {
    widget.onRefreshData(0).whenComplete(() {
      _refreshController.value.refreshCompleted();
      _refreshController.value.loadComplete();
      widget.isThatEndOfList.value = false;
      lengthOfPosts.value = 5;
    });
  }

  onSmarterLoading() {
    if (!widget.isThatEndOfList.value) {
      widget.onRefreshData(lengthOfPosts.value).whenComplete(() {
        _refreshController.value.loadComplete();
        if (lengthOfPosts.value >= widget.posts.length) {
          _refreshController.value.loadNoData();
          widget.isThatEndOfList.value = true;
        } else {
          lengthOfPosts.value += 5;
        }
      });
    } else {
      _refreshController.value.loadComplete();
      _refreshController.value.loadNoData();
    }
  }

  CustomFooter customFooter() {
    return CustomFooter(
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
            child = Text(StringsManager.clickRetry.tr(),
                style: Theme.of(context).textTheme.bodyText1);
            break;
          case LoadStatus.noMore:
            child = Container();
            break;
          default:
            child = circularProgressIndicator(context);
            break;
        }
        return SizedBox(
          height: 60,
          child: Center(
            child: child,
          ),
        );
      },
    );
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
      child: FadeTransition(
        opacity: _scaleController,
        child: ScaleTransition(
          child: circularProgressIndicator(context),
          scale: _scaleController,
        ),
      ),
      alignment: Alignment.center,
    );
  }

  CircularProgressIndicator circularProgressIndicator(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: 1.5,
      color: Theme.of(context).iconTheme.color,
      backgroundColor: Theme.of(context).dividerColor,
    );
  }

  Widget noMoreData(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorManager.blackRed,
                  ColorManager.redAccent,
                  ColorManager.yellow,
                ],
              ),
            ),
            child: SvgPicture.asset(IconsAssets.noMoreData,
                color: ColorManager.transparent),
          ),
        ],
      ),
    );
  }
}
