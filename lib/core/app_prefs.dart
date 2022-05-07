import 'package:flutter/material.dart';
import 'package:instegram/config/themes/app_theme.dart';
import 'package:instegram/core/resources/langauge_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefsKeyLang = "PREFS_KEY_LANG";
const String prefsKeyMode = "PREFS_KEY_MODE";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(prefsKeyLang);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.english.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.arabic.getValue()) {
      _sharedPreferences.setString(
          prefsKeyLang, LanguageType.english.getValue());
    } else {
      _sharedPreferences.setString(
          prefsKeyLang, LanguageType.arabic.getValue());
    }
  }

  Future<Locale> getLocal() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.arabic.getValue()) {
      return arabicLocal;
    } else {
      return englishLocal;
    }
  }
}

class AppPrefMode {
  final SharedPreferences _sharedPreferences;

  AppPrefMode(this._sharedPreferences);

  ThemeData getAppMode() {
    String? mode = _sharedPreferences.getString(prefsKeyMode);
    if (mode != null && mode.isNotEmpty) {
      return mode == "light" ? AppTheme.light : AppTheme.dark;
    } else {
      return AppTheme.light;
    }
  }

  String getAppModeString() {
    String? mode = _sharedPreferences.getString(prefsKeyMode);
    return mode ?? "light";
  }

  void changeAppMode() async {
    ThemeData currentLang = getAppMode();

    if (currentLang == AppTheme.light) {
      _sharedPreferences.setString(prefsKeyMode, "dark");
    } else {
      _sharedPreferences.setString(prefsKeyMode, "light");
    }
  }
}
