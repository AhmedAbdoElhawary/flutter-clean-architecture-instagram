import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';

class ThemeOfApp {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  ThemeMode get theme => isThemeDark() ? ThemeMode.dark : ThemeMode.light;

  bool isThemeDark() => _box.read(_key) ?? false;

  saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(isThemeDark() ? ThemeMode.light : ThemeMode.dark);
    saveThemeToBox(!isThemeDark());
  }
}
