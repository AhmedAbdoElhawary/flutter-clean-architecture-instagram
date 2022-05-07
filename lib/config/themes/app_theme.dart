import 'package:flutter/material.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/font_manager.dart';
import 'package:instegram/core/resources/styles_manager.dart';
//  Theme.of(context).selectedRowColor
class AppTheme {
  static ThemeData get light {
    return ThemeData(
        primaryColor: ColorManager.white,
        primaryColorLight: ColorManager.lightGrey,
        primarySwatch: Colors.grey,
        hintColor: ColorManager.lowOpacityGrey,
        shadowColor: ColorManager.veryLowOpacityGrey,
        bottomAppBarColor: Colors.grey,
        focusColor: ColorManager.black,
        disabledColor: ColorManager.black54,
        dialogBackgroundColor: ColorManager.black87,
        hoverColor: ColorManager.black45,
        indicatorColor: ColorManager.black38,
        cardColor: ColorManager.black26,
        dividerColor: ColorManager.black12,
        selectedRowColor:  ColorManager.lightGrey,
        scaffoldBackgroundColor: ColorManager.white,
        highlightColor:  ColorManager.black,
        canvasColor: ColorManager.transparent,
        splashColor: ColorManager.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: ColorManager.white,
          shadowColor: ColorManager.lowOpacityGrey,
            iconTheme:const IconThemeData(color: ColorManager.black),
          titleTextStyle:
              getNormalStyle(fontSize: FontSize.s16, color: ColorManager.black),
        ),
        textTheme: TextTheme(
            bodyText1: getNormalStyle(color: ColorManager.black),
            bodyText2: getNormalStyle(color: ColorManager.white),
            headline1: getNormalStyle(color: ColorManager.grey,fontSize: 15),
            headline2: getBoldStyle(color: ColorManager.black,fontSize: 15)));
  }

  static ThemeData get dark {
    return ThemeData(
      primaryColor: ColorManager.black,
      primaryColorLight: ColorManager.black87,
      primarySwatch: Colors.grey,
      hintColor: ColorManager.darkGray,
      shadowColor: ColorManager.white1,
      focusColor: ColorManager.white,
      dialogBackgroundColor: ColorManager.white,
      hoverColor: ColorManager.grey,
      indicatorColor: ColorManager.grey,
      cardColor: ColorManager.grey,
      dividerColor: ColorManager.grey,
      highlightColor:  ColorManager.grey,

      selectedRowColor:  ColorManager.darkGray,
      disabledColor: ColorManager.white,

      scaffoldBackgroundColor: ColorManager.black,
      canvasColor: ColorManager.transparent,
      splashColor: ColorManager.darkGray,
      appBarTheme: AppBarTheme(
        elevation: 0,
        iconTheme:const IconThemeData(color: ColorManager.white),
        color: ColorManager.black,
        shadowColor: ColorManager.lowOpacityGrey,
        titleTextStyle:
            getNormalStyle(fontSize: FontSize.s16, color: ColorManager.white),
      ),
      textTheme: TextTheme(
          bodyText1: getNormalStyle(color: ColorManager.white),
          bodyText2: getNormalStyle(color: ColorManager.black),
          headline1: getNormalStyle(color: ColorManager.grey,fontSize: 15),
          headline2: getBoldStyle(color: ColorManager.white,fontSize: 15)),
    );
  }
}
