import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram/core/resources/langauge_manager.dart';
import 'package:instagram/presentation/widgets/belong_to/main_w/material_app.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utility/injector.dart';

Future<void> main() async {
  final sharePrefs = await init();
  Widget myApp = MyApp(sharePrefs: sharePrefs);
  runApp(easyLocalization(myApp));
}

EasyLocalization easyLocalization(Widget myApp) {
  return EasyLocalization(
      child: Phoenix(child: myApp),
      supportedLocales: const [arabicLocal, englishLocal],
      path: assetPathLocalisations);
}

Future<SharedPreferences> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await PhotoManager.requestPermissionExtend();
  await Firebase.initializeApp();
  await initializeDependencies();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  return await SharedPreferences.getInstance();
}
