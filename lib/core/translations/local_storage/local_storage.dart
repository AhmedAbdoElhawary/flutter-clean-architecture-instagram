import 'package:get_storage/get_storage.dart';

class LocalStorage {
  void saveLanguageToDisk(String lang) async {
    await GetStorage().write('lang', lang);
  }

  dynamic get languageSelected async {
    return await GetStorage().read('lang');
  }
}
