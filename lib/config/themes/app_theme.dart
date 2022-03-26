import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.white,
      ),
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.transparent,
    );
  }
}
