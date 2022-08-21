import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagram/core/translations/local_storage/local_storage.dart';

class AppLanguage extends GetxController {
  String appLocale = 'en';

  @override
  void onInit() async {
    super.onInit();
    LocalStorage localStorage = LocalStorage();

    appLocale = await localStorage.languageSelected ?? 'en';
    update();
    Get.updateLocale(Locale(appLocale));
  }

  void changeLanguage() async {
    LocalStorage localStorage = LocalStorage();

    if (appLocale == 'en') {
      appLocale = 'ar';
      localStorage.saveLanguageToDisk('ar');
    } else {
      appLocale = 'en';
      localStorage.saveLanguageToDisk('en');
    }
    update();
  }
}
