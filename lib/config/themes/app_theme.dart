import 'package:flutter/material.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/font_manager.dart';
import 'package:instegram/core/resources/styles_manager.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: ColorManager.white,
        shadowColor: ColorManager.lowOpacityGrey,
        titleTextStyle:
        getNormalStyle(fontSize: FontSize.s16),
      ),
    );
  }
}
