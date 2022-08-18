import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/strings_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/data/models/post.dart';
import 'package:instagram/data/models/user_personal_info.dart';
import 'package:instagram/presentation/customPackages/sliding_sheet/sheet_pop_container.dart';
import 'package:instagram/presentation/customPackages/sliding_sheet/specs.dart';
import 'package:instagram/presentation/widgets/belong_to/time_line_w/send_to_users.dart';
import 'package:instagram/presentation/widgets/global/popup_widgets/web/share_post.dart';

class ShareButton extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final bool showOnlyBottomSheet;
  const ShareButton(
      {Key? key, required this.postInfo, this.showOnlyBottomSheet = false})
      : super(key: key);

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  final _bottomSheetMessageTextController = TextEditingController();
  final _bottomSheetSearchTextController = TextEditingController();
  @override
  void initState() {
    if (widget.showOnlyBottomSheet) {
      if (isThatMobile) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) async => await draggableBottomSheet());
      } else {
        Navigator.of(context).push(
          heroDialogRoute(),
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return shareButton();
  }

  Padding shareButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 15.0),
      child: GestureDetector(
        child: iconsOfImagePost(IconsAssets.send1Icon, lowHeight: true),
        onTap: () async {
          if (isThatMobile) {
            return draggableBottomSheet();
          } else {
            Navigator.of(context).push(
              heroDialogRoute(),
            );
          }
        },
      ),
    );
  }

  HeroDialogRoute<dynamic> heroDialogRoute() {
    return HeroDialogRoute(
      builder: (context) => PopupSharePost(
        postInfo: widget.postInfo.value,
        publisherInfo: widget.postInfo.value.publisherInfo!,
      ),
    );
  }

  SvgPicture iconsOfImagePost(String path, {bool lowHeight = false}) {
    return SvgPicture.asset(
      path,
      color: Theme.of(context).focusColor,
      height: lowHeight ? 22 : 28,
    );
  }

  Future<void> draggableBottomSheet() async {
    return showSlidingBottomSheet<void>(
      context,
      builder: (BuildContext context) => SlidingSheetDialog(
        cornerRadius: 16,
        color: Theme.of(context).splashColor,
        snapSpec: const SnapSpec(
          initialSnap: 1,
          snappings: [.4, 1, .7],
        ),
        builder: buildSheet,
        headerBuilder: (context, state) => Material(
          child: upperWidgets(context),
        ),
      ),
    );
  }

  Column upperWidgets(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        dashIcon(context),
        Row(
          children: [
            postImage(),
            const SizedBox(width: 12),
            textFieldOfMessage(),
          ],
        ),
        searchBar(context)
      ],
    );
  }

  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          top: 30.0, end: 20, start: 20, bottom: 10),
      child: Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          cursorColor: ColorManager.teal,
          style: Theme.of(context).textTheme.bodyText1,
          controller: _bottomSheetSearchTextController,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: ColorManager.lowOpacityGrey,
              ),
              contentPadding: const EdgeInsetsDirectional.all(12),
              hintText: StringsManager.search.tr(),
              hintStyle: Theme.of(context).textTheme.headline1,
              border: InputBorder.none),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Flexible textFieldOfMessage() {
    return Flexible(
      child: TextField(
        controller: _bottomSheetMessageTextController,
        cursorColor: ColorManager.teal,
        decoration: InputDecoration(
          hintText: StringsManager.writeMessage.tr(),
          hintStyle: const TextStyle(
            color: ColorManager.grey,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Padding postImage() {
    String postImageUrl = widget.postInfo.value.imagesUrls.length > 1
        ? widget.postInfo.value.imagesUrls[0]
        : widget.postInfo.value.postUrl;
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        width: 50,
        height: 45,
        decoration: BoxDecoration(
          color: ColorManager.grey,
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: NetworkImage(postImageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Padding dashIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10),
      child: Container(
        width: 45,
        height: 4.5,
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.headline4!.color,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  clearTextsController(bool clearText) {
    setState(() {
      if (clearText) {
        _bottomSheetMessageTextController.clear();
        _bottomSheetSearchTextController.clear();
      }
    });
  }

  Widget buildSheet(_, __) => Material(
        child: SendToUsers(
          publisherInfo: widget.postInfo.value.publisherInfo!,
          messageTextController: _bottomSheetMessageTextController,
          postInfo: widget.postInfo.value,
          clearTexts: clearTextsController,
          selectedUsersInfo: ValueNotifier<List<UserPersonalInfo>>([]),
        ),
      );
}
