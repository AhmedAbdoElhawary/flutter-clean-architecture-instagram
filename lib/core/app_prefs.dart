import 'package:flutter/material.dart';
import 'package:instegram/core/resources/langauge_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefsKeyLang = "PREFS_KEY_LANG";

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
