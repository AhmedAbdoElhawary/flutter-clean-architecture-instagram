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
      focusColor: ColorManager.black,
      disabledColor: ColorManager.black54,
      dialogBackgroundColor: ColorManager.black87,
      hoverColor:
          isThatMobile ? ColorManager.black45 : ColorManager.transparent,
      indicatorColor: ColorManager.black38,
      dividerColor: ColorManager.black12,
        cardColor: ColorManager.lightBlack,
      scaffoldBackgroundColor:
          isThatMobile ? ColorManager.white : ColorManager.customGreyForWeb,
      iconTheme: const IconThemeData(color: ColorManager.black38),
      chipTheme:
          const ChipThemeData(backgroundColor: ColorManager.veryLowOpacityGrey),
      highlightColor: ColorManager.lowOpacityGrey,
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
        bodyLarge: getNormalStyle(color: ColorManager.black),
        bodyMedium: getNormalStyle(color: ColorManager.imageGrey),
        bodySmall: getNormalStyle(color: ColorManager.grey),
        displayLarge: getNormalStyle(color: ColorManager.grey, fontSize: 15),
        displayMedium: getBoldStyle(color: ColorManager.black, fontSize: 15),
        displaySmall: getMediumStyle(color: ColorManager.black, fontSize: 15),
        headlineSmall: getNormalStyle(color: ColorManager.shimmerLightGrey),
        titleLarge: getNormalStyle(color: Colors.white),
        titleSmall: getNormalStyle(color: ColorManager.darkWhite),
        titleMedium: getNormalStyle(color: ColorManager.lightGrey),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: ColorManager.black26),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      primaryColor: ColorManager.black,
      primaryColorLight: ColorManager.black54,
      primarySwatch: Colors.grey,
      hintColor: ColorManager.darkGray,
      shadowColor: ColorManager.darkGray,
      focusColor: ColorManager.white,
      dialogBackgroundColor: ColorManager.white,
      highlightColor: ColorManager.grey,
      hoverColor: isThatMobile ? ColorManager.grey : ColorManager.transparent,
      indicatorColor: ColorManager.grey,
      dividerColor: ColorManager.grey,
      iconTheme: const IconThemeData(color: ColorManager.white),
      chipTheme:
          const ChipThemeData(backgroundColor: ColorManager.lightDarkGray),
      cardColor:  ColorManager.darkGray,
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
        bodyLarge: getNormalStyle(color: ColorManager.white),
        bodyMedium: getNormalStyle(color: ColorManager.darkGray),
        bodySmall: getNormalStyle(color: ColorManager.lightGrey),
        displayLarge: getNormalStyle(color: ColorManager.grey, fontSize: 15),
        displayMedium: getBoldStyle(color: ColorManager.white, fontSize: 15),
        displaySmall: getMediumStyle(color: ColorManager.white, fontSize: 15),
        headlineSmall: getNormalStyle(color: Colors.grey[500]!),
        titleLarge: getNormalStyle(color: ColorManager.shimmerDarkGrey),
        titleSmall: getNormalStyle(color: ColorManager.darkGray),
        titleMedium: getNormalStyle(color: ColorManager.darkGray),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: ColorManager.grey),
    );
  }
}
