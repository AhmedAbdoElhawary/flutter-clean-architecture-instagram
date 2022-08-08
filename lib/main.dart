import 'package:custom_gallery_display/custom_gallery_display.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram/core/private_keys.dart';
import 'package:instagram/core/resources/langauge_manager.dart';
import 'package:instagram/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utility/injector.dart';

Future<void> main() async {
  final sharePrefs = await init();

  Widget myApp = MyApp(sharePrefs: sharePrefs);
  runApp(easyLocalization(myApp));
}

EasyLocalization easyLocalization(Widget myApp) {
  return EasyLocalization(
      supportedLocales: const [arabicLocal, englishLocal],
      path: assetPathLocalisations,
      child: Phoenix(child: myApp),);
}

Future<SharedPreferences> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
      // I deleted private_keys in github project,
      // so create your own firebase project and add your web private keys here and in web/index.html.
    await Firebase.initializeApp(
      options: FirebaseOptions(
        measurementId:measurementId ,
        databaseURL: databaseURL,
        authDomain:authDomain,
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket,
      ),
    );
  } else {
    await Firebase.initializeApp();
    await CustomGalleryPermissions.requestPermissionExtend();
  }
  await EasyLocalization.ensureInitialized();
  await initializeDependencies();
  await GetStorage.init();
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  return await SharedPreferences.getInstance();
}
