import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/font_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
        primaryColor: ColorManager.white,
        primaryColorLight: ColorManager.lightGrey,
        primarySwatch: Colors.grey,
        hintColor: ColorManager.lowOpacityGrey,
        shadowColor: ColorManager.veryLowOpacityGrey,
        bottomAppBarColor: ColorManager.black26,
        focusColor: ColorManager.black,
        disabledColor: ColorManager.black54,
        dialogBackgroundColor: ColorManager.black87,
        hoverColor:
            isThatMobile ? ColorManager.black45 : ColorManager.transparent,
        indicatorColor: ColorManager.black38,
        dividerColor: ColorManager.black12,
        backgroundColor: ColorManager.lightBlack,
        selectedRowColor: ColorManager.lightGrey,
        toggleableActiveColor: ColorManager.darkWhite,
        scaffoldBackgroundColor: ColorManager.customGreyForWeb,
        iconTheme: const IconThemeData(color: ColorManager.black38),
        errorColor: ColorManager.black,
        canvasColor: ColorManager.transparent,
        splashColor: ColorManager.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: ColorManager.white,
          shadowColor: ColorManager.lowOpacityGrey,
          iconTheme: const IconThemeData(color: ColorManager.black),
          titleTextStyle:
              getNormalStyle(fontSize: FontSize.s16, color: ColorManager.black),
        ),
        textTheme: TextTheme(
            bodyText1: getNormalStyle(color: ColorManager.black, fontSize: 15),
            bodyText2: getNormalStyle(color: ColorManager.white),
            headline1: getNormalStyle(color: ColorManager.grey, fontSize: 15),
            headline2: getBoldStyle(color: ColorManager.black, fontSize: 15),
            headline3: getMediumStyle(color: ColorManager.black, fontSize: 15),
            headline4:
                getNormalStyle(color: ColorManager.black54, fontSize: 15),
            headline5: getNormalStyle(color: ColorManager.shimmerLightGrey),
            headline6: getNormalStyle(color: Colors.white),
            subtitle1: getNormalStyle(color: ColorManager.customGrey)));
  }

  static ThemeData get dark {
    return ThemeData(
      primaryColor: ColorManager.black,
      primaryColorLight: ColorManager.black54,
      primarySwatch: Colors.grey,
      hintColor: ColorManager.darkGray,
      shadowColor: ColorManager.darkWhite,
      focusColor: ColorManager.white,
      dialogBackgroundColor: ColorManager.white,
      hoverColor: isThatMobile ? ColorManager.grey : ColorManager.transparent,
      indicatorColor: ColorManager.grey,
      dividerColor: ColorManager.grey,
      bottomAppBarColor: ColorManager.grey,
      toggleableActiveColor: ColorManager.black54,
      iconTheme: const IconThemeData(color: ColorManager.white),
      backgroundColor: ColorManager.darkGray,
      selectedRowColor: ColorManager.darkGray,
      errorColor: ColorManager.grey,
      disabledColor: ColorManager.white,
      scaffoldBackgroundColor: ColorManager.black,
      canvasColor: ColorManager.transparent,
      splashColor: ColorManager.darkGray,
      appBarTheme: AppBarTheme(
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorManager.white),
        color: ColorManager.black,
        shadowColor: ColorManager.lowOpacityGrey,
        titleTextStyle:
            getNormalStyle(fontSize: FontSize.s16, color: ColorManager.white),
      ),
      textTheme: TextTheme(
          bodyText1: getNormalStyle(color: ColorManager.white),
          bodyText2: getNormalStyle(color: ColorManager.black),
          headline1: getNormalStyle(color: ColorManager.grey, fontSize: 15),
          headline2: getBoldStyle(color: ColorManager.white, fontSize: 15),
          headline3: getMediumStyle(color: ColorManager.white, fontSize: 15),
          headline4: getNormalStyle(color: ColorManager.grey, fontSize: 15),
          headline5: getNormalStyle(color: Colors.grey[500]!),
          headline6: getNormalStyle(color: ColorManager.shimmerDarkGrey),
          subtitle1: getNormalStyle(color: ColorManager.customGrey)),
    );
  }
}
