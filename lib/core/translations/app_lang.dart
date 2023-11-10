import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppLanguage extends GetxController {
  static String tag = "app_lang";
  static AppLanguage getInstance() {
    if (Get.isRegistered<AppLanguage>(tag: tag)) {
      return Get.find<AppLanguage>(tag: tag);
    }
    return Get.put(AppLanguage(), tag: tag);
  }

  final getStorage = GetStorage("AppLang");

  void saveLanguageToDisk(String lang) async {
    await getStorage.write('lang', lang);
  }

  String get languageSelected => getStorage.read<String?>('lang') ?? "en";

  bool get isLangEnglish => languageSelected == "en";

  @override
  void onInit() async {
    super.onInit();

    Get.updateLocale(Locale(languageSelected));
    update();
  }

  void changeLanguage() async {
    if (languageSelected == 'en') {
      saveLanguageToDisk('ar');
    } else {
      saveLanguageToDisk('en');
    }
    update();
  }
}
