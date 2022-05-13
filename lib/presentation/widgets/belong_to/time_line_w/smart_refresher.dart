import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/presentation/widgets/custom_circular_progress.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SmarterRefresh extends StatefulWidget {
  final Widget child;
  final List postsIds;
  final ValueNotifier<bool> isThatEndOfList;
  final AsyncValueSetter<int> onRefreshData;
  const SmarterRefresh(
      {required this.onRefreshData,
      required this.child,
      required this.isThatEndOfList,
      required this.postsIds,
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
  List ids = [];
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
          widget.onRefreshData(0).whenComplete(() {
            _refreshController.refreshCompleted();
            _refreshController.loadComplete();
            widget.isThatEndOfList.value = false;
            ids = widget.postsIds;
            setState(() {});
          });
        },
        onLoading: () async {
          if (!widget.isThatEndOfList.value) {
            widget.onRefreshData(widget.postsIds.length).whenComplete(() {
              _refreshController.loadComplete();
              if (ids.length == widget.postsIds.length) {
                _refreshController.loadNoData();
                widget.isThatEndOfList.value = true;
              } else {
                ids = widget.postsIds;
              }
              setState(() {});
            });
          } else {
            _refreshController.loadComplete();
            _refreshController.loadNoData();
          }
        },
        child: widget.child,
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
                child = Text(StringsManager.clickRetry.tr(),
                    style: Theme.of(context).textTheme.bodyText1);
                break;
              case LoadStatus.noMore:
                //TODO herrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
                child = Container();
                break;
              default:
                child = const ThineCircularProgress();
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
          builder: (context, mode) {
            return Container(
              color: Theme.of(context).backgroundColor,
              child: FadeTransition(
                opacity: _scaleController,
                child: ScaleTransition(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: ColorManager.black38,
                    backgroundColor: Theme.of(context).dividerColor,
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
  // Widget noMoreData(BuildContext context) {
  //   return Text(StringsManager.noMoreData.tr(),
  //       style: Theme.of(context).textTheme.bodyText1);
  // }
}
